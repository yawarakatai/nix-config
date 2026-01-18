{ pkgs, ... }:

{
  imports = [
    ../../lib/options.nix
    ./hardware-configuration.nix

    # Laptop-specific hardware modules
    ../../modules/system/input/touchpad.nix # Touchpad with natural scrolling, tap-to-click
    ../../modules/system/hardware/bluetooth.nix # Bluetooth support
    ../../modules/system/laptop/fingerprint.nix # Fingerprint reader for login/sudo
    ../../modules/system/laptop/power.nix # TLP power management for battery optimization
    ../../modules/system/hardware/webcam.nix # Webcam support
    ../../modules/system/input/keyboard/kanata.nix # Specified key layout remap
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Workaround for Alder Lake audio firmware signature verification failure
  # Use legacy HDA driver instead of SOF until firmware is properly signed
  # dsp_driver: 1=legacy HDA, 3=SOF (Smart Sound)
  boot.kernelParams = [
    "snd_intel_dspcfg.dsp_driver=1"
  ];

  # --- Locale Timezone Input methods ---

  time.timeZone = "Asia/Tokyo";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "ja_JP.UTF-8/UTF-8"
    ];
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

    # Japanese input method - fcitx5 with mozc
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-mozc
          fcitx5-gtk
        ];

        waylandFrontend = true;
      };
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # --- Application and Service Settings ---;
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchDocked = "suspend";
    HandleLidSwitchExternalPower = "suspend";
  };

  # --- My Options ---

  my = {
    user.name = "yawarakatai";
    system.monitors.primary = {
      name = "eDP-1";
      width = 2160;
      height = 1350;
      refresh = 59.940;
    };
  };

  # --- State Version ---
  # State version - DO NOT CHANGE after initial install
  system.stateVersion = "25.05";
}
