{
  inputs,
  lib,
  self,
  ...
}:

let
  hosts = self.nixosConfigurations;
in
{
  # Evaluation-level invariants in nix-unit format; names state the requirement.
  flake.tests = {
    nanodesu =
      let
        host = hosts.nanodesu;
        inherit (host) config;
        home = config.home-manager.users.yawarakatai;
        power = config.services.tlp.settings;
        touchpad = home.programs.niri.settings.input.touchpad;
        btrfsConfig =
          (host.extendModules {
            modules = [ { fileSystems."/".fsType = lib.mkForce "btrfs"; } ];
          }).config;
      in
      {
        "test needs ext4, trim and zram; root scrub is limited to Btrfs" = {
          expr = {
            rootFsType = config.fileSystems."/".fsType;
            autoScrub = config.services.btrfs.autoScrub.enable;
            fstrim = config.services.fstrim.enable;
            zram = config.zramSwap.enable;
            inherit (config) swapDevices;
            autoScrubOnBtrfs = btrfsConfig.services.btrfs.autoScrub.enable;
          };
          expected = {
            rootFsType = "ext4";
            autoScrub = false;
            fstrim = true;
            zram = true;
            swapDevices = [ ];
            autoScrubOnBtrfs = true;
          };
        };

        "test allows responsive battery operation with Intel P-state and EPP" = {
          expr = {
            tlp = config.services.tlp.enable;
            powerProfilesDaemon = config.services.power-profiles-daemon.enable;
            inherit (power)
              CPU_SCALING_GOVERNOR_ON_AC
              CPU_SCALING_GOVERNOR_ON_BAT
              CPU_ENERGY_PERF_POLICY_ON_BAT
              CPU_MAX_PERF_ON_BAT
              CPU_BOOST_ON_BAT
              PLATFORM_PROFILE_ON_BAT
              ;
          };
          expected = {
            tlp = true;
            powerProfilesDaemon = false;
            CPU_SCALING_GOVERNOR_ON_AC = "performance";
            CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
            CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_performance";
            CPU_MAX_PERF_ON_BAT = 100;
            CPU_BOOST_ON_BAT = 1;
            PLATFORM_PROFILE_ON_BAT = "balanced";
          };
        };

        "test keeps screen-sharing PipeWire without desktop audio or Bluetooth" = {
          expr = {
            pipewire = config.services.pipewire.enable;
            audio = config.services.pipewire.audio.enable;
            alsa = config.services.pipewire.alsa.enable;
            pulse = config.services.pipewire.pulse.enable;
            jack = config.services.pipewire.jack.enable;
            bluetooth = config.hardware.bluetooth.enable;
            blueman = config.services.blueman.enable;
          };
          expected = {
            pipewire = true;
            audio = false;
            alsa = false;
            pulse = false;
            jack = false;
            bluetooth = false;
            blueman = false;
          };
        };

        "test drops webcam and audio workarounds but keeps redistributable firmware" = {
          expr = {
            kernelModules = lib.intersectLists [ "uvcvideo" ] config.boot.kernelModules;
            kernelParams = lib.intersectLists [
              "intel_ipu6.dyndbg=+p"
              "snd_intel_dspcfg.dsp_driver=1"
            ] config.boot.kernelParams;
            redistributableFirmware = config.hardware.enableRedistributableFirmware;
          };
          expected = {
            kernelModules = [ ];
            kernelParams = [ ];
            redistributableFirmware = true;
          };
        };

        "test Niri owns the touchpad and keeps its pointer speed" = {
          expr = {
            libinput = config.services.libinput.enable;
            inherit (touchpad)
              dwt
              middle-emulation
              scroll-method
              accel-profile
              accel-speed
              ;
          };
          expected = {
            libinput = false;
            dwt = true;
            middle-emulation = true;
            scroll-method = "two-finger";
            accel-profile = "adaptive";
            accel-speed = 1.0;
          };
        };
      };

    kamo =
      let
        inherit (hosts.kamo) config;
        home = config.home-manager.users.${config.jovian.steam.user};
        secret = config.age.secrets.noctalia-storage-key;
        storage = home.programs.noctalia.settings.storage;
        sessionTracker = home.xdg.configFile."inhibit-short-session-tracker";
      in
      {
        "test boots into Gaming Mode and switches to Niri" = {
          expr = { inherit (config.jovian.steam) autoStart desktopSession; };
          expected = {
            autoStart = true;
            desktopSession = "niri";
          };
        };

        "test quick desktop switches do not trigger Steam's old bootstrap repair" = {
          expr = { inherit (sessionTracker) enable text; };
          expected = {
            enable = true;
            text = "";
          };
        };

        "test Bluetooth stays enabled without the unsupported BlueZ General.Enable" = {
          expr = {
            inherit (config.hardware.bluetooth) enable;
            generalEnable = config.hardware.bluetooth.settings.General ? Enable;
          };
          expected = {
            enable = true;
            generalEnable = false;
          };
        };

        "test keeps Jovian's AMD backlight rule for Steam brightness control" = {
          expr = {
            amdGpu = config.jovian.hardware.has.amd.gpu;
            backlightControl = config.jovian.hardware.amd.gpu.enableBacklightControl;
            udevRule = lib.hasInfix "/sys/class/backlight/%k/brightness" config.services.udev.extraRules;
          };
          expected = {
            amdGpu = true;
            backlightControl = true;
            udevRule = true;
          };
        };

        "test keeps a persistent 80% charge limit for docked use" = {
          expr = {
            service = config.systemd.services.battery-charge-threshold.enable;
            inherit (config.hardware.asus.battery) chargeUpto enableChargeUptoScript;
          };
          expected = {
            service = true;
            chargeUpto = 80;
            enableChargeUptoScript = false;
          };
        };

        "test keeps InputPlumber without loading the unused BMI323 IMU driver" = {
          expr = {
            inputplumber = config.services.inputplumber.enable;
            blacklisted = lib.elem "bmi323_i2c" config.boot.blacklistedKernelModules;
            loaded = lib.elem "bmi323_i2c" (config.boot.kernelModules ++ config.boot.initrd.kernelModules);
          };
          expected = {
            inputplumber = true;
            blacklisted = true;
            loaded = false;
          };
        };

        "test Noctalia uses the host's private storage key, not the login keyring" = {
          expr = {
            inherit (storage) key_source key_file;
            inherit (secret) owner mode;
          };
          expected = {
            key_source = "file";
            key_file = secret.path;
            owner = config.jovian.steam.user;
            mode = "0400";
          };
        };

        "test Noctalia stays attached only to Niri" = {
          expr = home.systemd.user.services.noctalia.Install.WantedBy;
          expected = [ "niri.service" ];
        };

        "test Niri prefers the internal panel without disabling the external display" = {
          expr = {
            internalFocus = home.programs.niri.settings.outputs."eDP-1".focus-at-startup;
            inherit (config.my.display.outputs."DP-2") enable primary;
          };
          expected = {
            internalFocus = true;
            enable = true;
            primary = false;
          };
        };
      };

    dayo =
      let
        inherit (hosts.dayo) config;
        fw = config.networking.firewall;
        repos = config.services.borgbackup.repos;
        rtw89 = [
          "rtw89_8852be"
          "rtw89_8852b"
          "rtw89_pci"
          "rtw89_core"
        ];
      in
      {
        "test opens router services only on its LAN interface" = {
          expr = {
            inherit (fw)
              allowedTCPPorts
              allowedUDPPorts
              allowedTCPPortRanges
              allowedUDPPortRanges
              trustedInterfaces
              extraInputRules
              ;
            interfaces = lib.attrNames fw.interfaces;
            inherit (config.networking.nat) forwardPorts dmzHost;
          };
          expected = {
            allowedTCPPorts = [ ];
            allowedUDPPorts = [ ];
            allowedTCPPortRanges = [ ];
            allowedUDPPortRanges = [ ];
            trustedInterfaces = [ "lo" ];
            extraInputRules = "";
            interfaces = [ config.my.router.lan ];
            forwardPorts = [ ];
            dmzHost = null;
          };
        };

        # The onboard Wi-Fi lacks Japanese radio certification.
        "test never loads the onboard Wi-Fi driver" = {
          expr = lib.subtractLists config.boot.blacklistedKernelModules rtw89;
          expected = [ ];
        };

        "test backup clients only append to their own quota-limited repository" = {
          expr = {
            hasRepos = repos != { };
            repos = lib.mapAttrs (_: repo: {
              inherit (repo) authorizedKeys;
              appendOnly = repo.authorizedKeysAppendOnly != [ ];
              quota = repo.quota != null;
            }) repos;
          };
          expected = {
            hasRepos = true;
            repos = lib.mapAttrs (_: _: {
              authorizedKeys = [ ];
              appendOnly = true;
              quota = true;
            }) repos;
          };
        };

        "test boots without the backup disk and never backs up onto its root disk" = {
          expr = {
            nofail = lib.elem "nofail" config.fileSystems."/srv/backup".options;
            requiresMounts = lib.mapAttrs (
              name: _: config.systemd.services."borgbackup-repo-${name}".unitConfig.RequiresMountsFor
            ) repos;
          };
          expected = {
            nofail = true;
            requiresMounts = lib.mapAttrs (_: _: "/srv/backup") repos;
          };
        };
      };

    # Trusted users can take over root through the store.
    "test only root is a Nix trusted user" = {
      expr = lib.mapAttrs (_: host: host.config.nix.settings.trusted-users) hosts;
      expected = lib.mapAttrs (_: _: [ "root" ]) hosts;
    };
  };

  perSystem =
    { pkgs, system, ... }:
    let
      lock = builtins.fromJSON (builtins.readFile ../../flake.lock);
      # The sandbox has no network, so every locked input (nested ones too) is
      # passed by store path; follows entries are lists and resolve on their own.
      overrideInputs =
        prefix: node: flakeInputs:
        lib.concatLists (
          lib.mapAttrsToList (
            name: ref:
            let
              path = prefix + name;
              input = flakeInputs.${name};
            in
            lib.optionals (lib.isString ref) (
              [ "--override-input ${path} ${input}" ] ++ overrideInputs "${path}/" ref (input.inputs or { })
            )
          ) (lock.nodes.${node}.inputs or { })
        );
    in
    {
      checks = lib.optionalAttrs (system == "x86_64-linux") {
        nix-unit = pkgs.runCommand "nix-unit" { nativeBuildInputs = [ pkgs.nix-unit ]; } ''
          export HOME="$PWD"
          # A private store keeps evaluation inside the sandbox.
          unset NIX_STORE
          export NIX_STORE_DIR=${builtins.storeDir}
          export NIX_REMOTE="$HOME/store"
          nix-unit \
            --extra-experimental-features flakes \
            ${lib.concatStringsSep " " (overrideInputs "" lock.root inputs)} \
            --flake ${self}#tests
          touch "$out"
        '';
      };
    };
}
