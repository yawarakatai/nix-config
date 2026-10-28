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
            !config.systemd.services.battery-charge-threshold.enable
            && !config.hardware.asus.battery.enableChargeUptoScript
          ) "The ASUS charge-limit writer must not override Steam UI changes.";
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
      };
    };
}
