{
  config,
  lib,
  options,
  ...
}:

let
  inherit (lib) mkOption types;
  cfg = config.my.router;
  lanAddress = "192.168.1.1";
  tunnel = "dslite";
in
{
  # IPv6 IPoE uplink with DS-Lite for IPv4; hosts only provide line facts.
  options.my.router = {
    wan = mkOption {
      type = types.str;
      description = "Interface connected to the ONU or home gateway.";
    };
    lan = mkOption {
      type = types.str;
      description = "Interface serving the home network.";
    };
    aftr = mkOption {
      type = types.str;
      description = "IPv6 address of the ISP's DS-Lite AFTR.";
    };
  };

  config = {
    networking = {
      useNetworkd = true;
      useDHCP = false;

      nftables.enable = true;
      firewall = {
        filterForward = true;
        # The network edge must drop spoofed sources; nixpkgs defaults to loose.
        checkReversePath = "strict";
        # IPv4 forwarding to the tunnel comes from networking.nat.
        extraForwardRules = ''
          iifname "${cfg.lan}" oifname "${cfg.wan}" accept
        '';
        interfaces.${cfg.lan} = {
          allowedTCPPorts = [
            22
            53
          ];
          allowedUDPPorts = [
            53
            67
          ];
        };
      };

      nat = {
        enable = true;
        internalInterfaces = [ cfg.lan ];
        externalInterface = tunnel;
      };

      nftables.tables.mss-clamp = {
        family = "inet";
        # The tunnel MTU is below 1500, and path MTU discovery is often broken upstream.
        content = ''
          chain forward {
            type filter hook forward priority mangle; policy accept;
            oifname "${tunnel}" tcp flags syn / syn,rst tcp option maxseg size set rt mtu
          }
        '';
      };

      # DNS over TLS checks certificates against the clock, so syncing the clock
      # must not need DNS: ntp.nict.jp's addresses come first.
      timeServers = [
        "2001:df0:232:eea0::fff3"
        "2001:df0:232:eea0::fff4"
      ]
      ++ options.networking.timeServers.default;
    };

    services.openssh = {
      # SSH stays reachable from the LAN only, never from the WAN.
      openFirewall = false;
      # Only declared keys log in, so a foothold cannot persist through ~/.ssh.
      authorizedKeysInHomedir = false;
    };

    services.resolved.settings.Resolve = {
      DNSStubListenerExtra = lanAddress;
      # Multicast name lookups would also query the WAN link.
      LLMNR = false;
      MulticastDNS = false;
      # The NGN's resolvers strip DNSSEC signatures, so validation fails on them.
      # These validate and are reached over native IPv6, independent of the tunnel.
      # resolved moves down the list only on failure: Cloudflare first, then Quad9.
      # TLS, verified against the name after "#", keeps the path from reading or
      # forging answers; DNSSEC alone can be downgraded on path.
      DNS = [
        "2606:4700:4700::1111#cloudflare-dns.com"
        "2606:4700:4700::1001#cloudflare-dns.com"
        "2620:fe::fe#dns.quad9.net"
        "2620:fe::9#dns.quad9.net"
      ];
      DNSOverTLS = true;
    };

    systemd.network = {
      enable = true;
      config.networkConfig.IPv6Forwarding = true;

      netdevs."20-${tunnel}" = {
        netdevConfig = {
          Kind = "ip6tnl";
          Name = tunnel;
          MTUBytes = "1460";
        };
        tunnelConfig = {
          Mode = "ipip6";
          Local = "slaac";
          Remote = cfg.aftr;
          # AFTRs commonly drop packets carrying the encapsulation limit option.
          EncapsulationLimit = "none";
        };
      };

      networks = {
        "10-wan" = {
          matchConfig.Name = cfg.wan;
          tunnel = [ tunnel ];
          networkConfig = {
            DHCP = "ipv6";
            # Forwarding disables RA acceptance unless it is requested explicitly.
            IPv6AcceptRA = true;
            LinkLocalAddressing = "ipv6";
          };
          dhcpV6Config = {
            PrefixDelegationHint = "::/60";
            UseDNS = false;
          };
          ipv6AcceptRAConfig.UseDNS = false;
          linkConfig.RequiredForOnline = "routable";
        };

        "20-${tunnel}" = {
          matchConfig.Name = tunnel;
          # RFC 6333 reserves 192.0.0.2 for the B4 end of the softwire.
          address = [ "192.0.0.2/29" ];
          routes = [ { Destination = "0.0.0.0/0"; } ];
          networkConfig.LinkLocalAddressing = "no";
        };

        "30-lan" = {
          matchConfig.Name = cfg.lan;
          address = [ "${lanAddress}/24" ];
          networkConfig = {
            DHCPServer = true;
            IPv6SendRA = true;
            DHCPPrefixDelegation = true;
            ConfigureWithoutCarrier = true;
          };
          dhcpServerConfig = {
            PoolOffset = 100;
            PoolSize = 100;
            DNS = [ lanAddress ];
          };
          dhcpPrefixDelegationConfig = {
            UplinkInterface = cfg.wan;
            SubnetId = 1;
          };
          linkConfig.RequiredForOnline = "no";
        };
      };
    };
  };
}
