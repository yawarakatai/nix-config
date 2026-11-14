{ config, lib, ... }:

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
      # The router owns every link; NetworkManager would fight networkd over them.
      networkmanager.enable = lib.mkForce false;
      useNetworkd = true;
      useDHCP = false;

      nftables.enable = true;
      firewall = {
        # Global ports would also open on the WAN; routers expose services per interface only.
        allowedTCPPorts = lib.mkForce [ ];
        allowedUDPPorts = lib.mkForce [ ];
        filterForward = true;
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
    };

    # SSH stays reachable from the LAN only, never from the WAN.
    services.openssh.openFirewall = false;

    services.resolved.settings.Resolve.DNSStubListenerExtra = lanAddress;

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
          dhcpV6Config.PrefixDelegationHint = "::/60";
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
