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
      checks = lib.optionalAttrs (system == "x86_64-linux") {
        nanodesu-laptop =
          let
            host = self.nixosConfigurations.nanodesu;
            inherit (host) config;
            home = config.home-manager.users.yawarakatai;
            power = config.services.tlp.settings;
            btrfsConfig =
              (host.extendModules {
                modules = [
                  { fileSystems."/".fsType = lib.mkForce "btrfs"; }
                ];
              }).config;
          in
          assert lib.assertMsg (
            config.fileSystems."/".fsType == "ext4"
            && !config.services.btrfs.autoScrub.enable
            && config.services.fstrim.enable
            && config.zramSwap.enable
            && config.swapDevices == [ ]
            && btrfsConfig.services.btrfs.autoScrub.enable
          ) "Nanodesu needs ext4, trim and zram; root scrub must be limited to Btrfs.";
          assert lib.assertMsg (
            config.services.tlp.enable
            && !config.services.power-profiles-daemon.enable
            && power.CPU_SCALING_GOVERNOR_ON_AC == "performance"
            && power.CPU_SCALING_GOVERNOR_ON_BAT == "powersave"
            && power.CPU_ENERGY_PERF_POLICY_ON_BAT == "balance_performance"
            && power.CPU_MAX_PERF_ON_BAT == 100
            && power.CPU_BOOST_ON_BAT == 1
            && power.PLATFORM_PROFILE_ON_BAT == "balanced"
          ) "Nanodesu must allow responsive battery operation with Intel P-state and EPP.";
          assert lib.assertMsg (
            config.services.pipewire.enable
            && !config.services.pipewire.audio.enable
            && !config.services.pipewire.alsa.enable
            && !config.services.pipewire.pulse.enable
            && !config.services.pipewire.jack.enable
            && !config.hardware.bluetooth.enable
            && !config.services.blueman.enable
          ) "Nanodesu needs screen-sharing PipeWire without desktop audio or Bluetooth services.";
          assert lib.assertMsg (
            !(lib.elem "uvcvideo" config.boot.kernelModules)
            && !(lib.elem "intel_ipu6.dyndbg=+p" config.boot.kernelParams)
            && !(lib.elem "snd_intel_dspcfg.dsp_driver=1" config.boot.kernelParams)
            && config.hardware.enableRedistributableFirmware
          ) "Nanodesu must drop webcam/audio workarounds without removing redistributable firmware.";
          assert lib.assertMsg (
            !config.services.libinput.enable
            && home.programs.niri.settings.input.touchpad.dwt
            && home.programs.niri.settings.input.touchpad.middle-emulation
            && home.programs.niri.settings.input.touchpad.scroll-method == "two-finger"
            && home.programs.niri.settings.input.touchpad.accel-profile == "adaptive"
            && home.programs.niri.settings.input.touchpad.accel-speed == 1.0
          ) "Niri must own Nanodesu's touchpad settings and retain its existing pointer speed.";
          pkgs.runCommand "nanodesu-laptop-check" { } ''
            touch "$out"
          '';

        kamo-handheld =
          let
            host = self.nixosConfigurations.kamo;
            inherit (host) config;
            home = config.home-manager.users.${config.jovian.steam.user};
            secret = config.age.secrets.noctalia-storage-key;
            storage = home.programs.noctalia.settings.storage;
          in
          assert lib.assertMsg (
            config.jovian.steam.autoStart && config.jovian.steam.desktopSession == "niri"
          ) "Kamo must boot into Gaming Mode and switch to Niri.";
          assert lib.assertMsg (
            home.xdg.configFile."inhibit-short-session-tracker".enable
            && home.xdg.configFile."inhibit-short-session-tracker".text == ""
          ) "Quick desktop switches must not trigger Steam's old bootstrap repair on Kamo.";
          assert lib.assertMsg (
            config.hardware.bluetooth.enable && !(config.hardware.bluetooth.settings.General ? Enable)
          ) "Bluetooth must stay enabled without the unsupported BlueZ General.Enable setting.";
          assert lib.assertMsg (
            config.jovian.hardware.has.amd.gpu
            && config.jovian.hardware.amd.gpu.enableBacklightControl
            && lib.hasInfix "/sys/class/backlight/%k/brightness" config.services.udev.extraRules
          ) "Kamo needs Jovian's AMD backlight access rule for Steam brightness control.";
          assert lib.assertMsg (
            config.systemd.services.battery-charge-threshold.enable
            && config.hardware.asus.battery.chargeUpto == 80
            && !config.hardware.asus.battery.enableChargeUptoScript
          ) "Kamo needs a persistent 80% charge limit for docked use.";
          assert lib.assertMsg (
            config.services.inputplumber.enable
            && lib.elem "bmi323_i2c" config.boot.blacklistedKernelModules
            && !(lib.elem "bmi323_i2c" config.boot.kernelModules)
            && !(lib.elem "bmi323_i2c" config.boot.initrd.kernelModules)
          ) "Kamo must keep InputPlumber enabled without loading the unused BMI323 IMU driver.";
          assert lib.assertMsg (
            storage.key_source == "file"
            && storage.key_file == secret.path
            && secret.owner == config.jovian.steam.user
            && secret.mode == "0400"
          ) "Noctalia must use the host's private storage key instead of the login keyring.";
          assert lib.assertMsg (
            home.systemd.user.services.noctalia.Install.WantedBy == [ "niri.service" ]
          ) "Noctalia must remain attached only to Niri.";
          assert lib.assertMsg (
            home.programs.niri.settings.outputs."eDP-1".focus-at-startup
            && config.my.display.outputs."DP-2".enable
            && !config.my.display.outputs."DP-2".primary
          ) "Niri must prefer the internal panel without disabling the external display.";
          pkgs.runCommand "kamo-handheld-check" { } ''
            ${pkgs.gnugrep}/bin/grep -F -- "-O eDP-1,'*'" \
              ${host.pkgs.jovianPackages.gamescope-session}/lib/steamos/gamescope-session
            touch "$out"
          '';

        dane-router-firewall =
          let
            inherit (self.nixosConfigurations.dane) config;
            fw = config.networking.firewall;
          in
          assert lib.assertMsg (
            fw.allowedTCPPorts == [ ]
            && fw.allowedUDPPorts == [ ]
            && fw.allowedTCPPortRanges == [ ]
            && fw.allowedUDPPortRanges == [ ]
            && lib.attrNames fw.interfaces == [ config.my.router.lan ]
            && fw.trustedInterfaces == [ "lo" ]
            && fw.extraInputRules == ""
            && config.networking.nat.forwardPorts == [ ]
            && config.networking.nat.dmzHost == null
          ) "Dane may only open router services on its LAN interface.";
          assert lib.assertMsg (lib.all (m: lib.elem m config.boot.blacklistedKernelModules) [
            "rtw89_8852be"
            "rtw89_8852b"
            "rtw89_pci"
            "rtw89_core"
          ]) "Dane's onboard Wi-Fi lacks Japanese radio certification and must never load.";
          pkgs.runCommand "dane-router-firewall-check" { } ''
            touch "$out"
          '';

        dane-backup =
          let
            inherit (self.nixosConfigurations.dane) config;
            repos = config.services.borgbackup.repos;
          in
          assert lib.assertMsg (
            repos != { }
            && lib.all (
              repo: repo.authorizedKeys == [ ] && repo.authorizedKeysAppendOnly != [ ] && repo.quota != null
            ) (lib.attrValues repos)
          ) "Backup clients must only append to their own quota-limited repository.";
          assert lib.assertMsg (
            lib.elem "nofail" config.fileSystems."/srv/backup".options
            && lib.all (
              name:
              config.systemd.services."borgbackup-repo-${name}".unitConfig.RequiresMountsFor == "/srv/backup"
            ) (lib.attrNames repos)
          ) "The router must boot without the backup disk and never back up onto its root disk.";
          pkgs.runCommand "dane-backup-check" { } ''
            touch "$out"
          '';

        # Simulates the NGN and the DS-Lite AFTR so dane's router rules can be probed from both sides.
        dane-router = pkgs.testers.runNixOSTest {
          name = "dane-router";

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
              { config, lib, ... }:
              {
                imports = [
                  ../core/networking.nix
                  ../services/router.nix
                  ../../hosts/dane/system.nix
                ];
                virtualisation.interfaces = {
                  ${config.my.router.wan}.vlan = 1;
                  ${config.my.router.lan}.vlan = 2;
                };
                my.router.aftr = lib.mkForce "2001:db8::1";
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
