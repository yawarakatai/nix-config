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
