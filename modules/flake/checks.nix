{ self, ... }:

{
  perSystem =
    {
      lib,
      pkgs,
      system,
      ...
    }:
    {
      checks = {
        lint =
          pkgs.runCommand "lint"
            {
              nativeBuildInputs = [
                pkgs.statix
                pkgs.deadnix
              ];
            }
            ''
              cd ${self}
              statix check -i 'hosts/*/generated/hardware-configuration.nix'
              deadnix --fail --exclude hosts/*/generated/hardware-configuration.nix
              touch $out
            '';

        # Instantiating drvPaths catches evaluation errors without building every Home Manager package.
        home-configurations = pkgs.writeText "home-configurations" (
          lib.concatMapStringsSep "\n" (
            home: builtins.unsafeDiscardStringContext home.activationPackage.drvPath
          ) (lib.attrValues self.homeConfigurations)
        );
      }
      // lib.optionalAttrs (system == "x86_64-linux") {
        # Reads a built file, so it cannot be a nix-unit test.
        kamo-gamescope-internal-panel = pkgs.runCommand "kamo-gamescope-internal-panel" { } ''
          ${pkgs.gnugrep}/bin/grep -F -- "-O eDP-1,'*'" \
            ${self.nixosConfigurations.kamo.pkgs.jovianPackages.gamescope-session}/lib/steamos/gamescope-session
          touch "$out"
        '';

        # Simulates the NGN and the DS-Lite AFTR so dayo's router rules can be probed from both sides.
        dayo-router = pkgs.testers.runNixOSTest {
          name = "dayo-router";

          nodes = {
            isp = {
              virtualisation.interfaces.ngn.vlan = 1;
              networking = {
                useNetworkd = true;
                useDHCP = false;
                firewall.enable = false;
              };
              systemd.network = {
                netdevs."10-aftr" = {
                  netdevConfig = {
                    Kind = "ip6tnl";
                    Name = "aftr";
                  };
                  tunnelConfig = {
                    Mode = "ipip6";
                    Local = "2001:db8::1";
                    Remote = "2001:db8::2";
                    EncapsulationLimit = "none";
                  };
                };
                networks = {
                  "10-ngn" = {
                    matchConfig.Name = "ngn";
                    address = [ "2001:db8::1/64" ];
                    tunnel = [ "aftr" ];
                    networkConfig.IPv6SendRA = true;
                    ipv6Prefixes = [ { Prefix = "2001:db8::/64"; } ];
                    # Lets WAN-side probes aim at the LAN directly.
                    routes = [
                      {
                        Destination = "2001:db8:1::/64";
                        Gateway = "2001:db8::2";
                      }
                    ];
                  };
                  "20-aftr" = {
                    matchConfig.Name = "aftr";
                    address = [
                      "192.0.0.1/29"
                      "203.0.113.1/32"
                    ];
                    routes = [ { Destination = "192.168.1.0/24"; } ];
                  };
                };
              };
              environment.systemPackages = with pkgs; [
                curl
                dig
                netcat-openbsd
                nmap
              ];
              systemd.services.web = {
                wantedBy = [ "multi-user.target" ];
                serviceConfig.ExecStart = "${pkgs.python3}/bin/python3 -m http.server --bind :: 8000";
              };
            };

            router =
              { config, ... }:
              {
                imports = [
                  ../core/networking.nix
                  ../services/router.nix
                ];
                virtualisation.interfaces = {
                  ${config.my.router.wan}.vlan = 1;
                  ${config.my.router.lan}.vlan = 2;
                };
                # Dayo's real interface facts, with the simulated AFTR in place of the ISP's.
                my.router = self.nixosConfigurations.dayo.config.my.router // {
                  aftr = "2001:db8::1";
                };
                services.openssh.enable = true;
                environment.systemPackages = [ pkgs.curl ];
                systemd.network.networks = {
                  "10-wan".ipv6AcceptRAConfig.Token = "::2";
                  # Stands in for a delegated prefix, which the NGN may not provide.
                  "30-lan".address = [ "2001:db8:1::1/64" ];
                };
              };

            client = {
              virtualisation.interfaces.lan.vlan = 2;
              networking = {
                useNetworkd = true;
                useDHCP = false;
                # Only the router may stand between the WAN and this host.
                firewall.enable = false;
              };
              systemd.network.networks."10-lan" = {
                matchConfig.Name = "lan";
                networkConfig = {
                  DHCP = "ipv4";
                  IPv6AcceptRA = false;
                };
                address = [ "2001:db8:1::2/64" ];
                routes = [ { Gateway = "2001:db8:1::1"; } ];
              };
              environment.systemPackages = with pkgs; [
                curl
                dig
                netcat-openbsd
              ];
              systemd.services.web = {
                wantedBy = [ "multi-user.target" ];
                serviceConfig.ExecStart = "${pkgs.python3}/bin/python3 -m http.server --bind :: 8000";
              };
            };
          };

          testScript = ''
            start_all()

            client.wait_until_succeeds("ip -4 -o addr show dev lan | grep -q 'inet 192.168.1.1[0-9][0-9]/24'")
            client_ip = client.succeed("ip -4 -o addr show dev lan | awk '{print $4}' | cut -d/ -f1").strip()
            client.wait_for_open_port(8000)
            isp.wait_for_open_port(8000)

            with subtest("LAN reaches the IPv4 internet through DS-Lite"):
                client.wait_until_succeeds("curl -sf --max-time 3 http://203.0.113.1:8000/", timeout=60)

            with subtest("LAN reaches the IPv6 internet"):
                client.succeed("curl -sf --max-time 3 'http://[2001:db8::1]:8000/'")

            with subtest("Router services answer on the LAN"):
                client.succeed("nc -z -w 3 192.168.1.1 22")
                client.succeed("dig +time=2 +tries=1 @192.168.1.1 router")

            with subtest("WAN sees no open router ports"):
                isp.succeed("ping -c1 -W2 2001:db8::2")
                isp.succeed("ping -c1 -W2 192.0.0.2")
                for target in ["2001:db8::2", "2001:db8:1::1", "192.0.0.2", "192.168.1.1"]:
                    family = "-6 " if ":" in target else ""
                    scan = isp.succeed(f"nmap {family}-Pn -T5 --min-rate 5000 --max-retries 1 -p- -oG - {target}")
                    assert "/open/" not in scan, scan
                isp.fail("dig +time=2 +tries=1 @192.168.1.1 router")

            with subtest("WAN cannot open connections into the LAN"):
                # The LAN listener is up and routable, so a failure below can only be the router's filter.
                router.succeed(f"curl -sf --max-time 3 http://{client_ip}:8000/")
                router.succeed("curl -sf --max-time 3 'http://[2001:db8:1::2]:8000/'")
                isp.succeed("ping -c1 -W2 2001:db8:1::2")
                isp.fail("curl -sf --max-time 3 'http://[2001:db8:1::2]:8000/'")
                isp.fail(f"curl -sf --max-time 3 http://{client_ip}:8000/")
          '';
        };
      };
    };
}
