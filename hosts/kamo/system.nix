{
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  edp1 = config.my.display.outputs."eDP-1";
in
{
  age.secrets.noctalia-storage-key = {
    rekeyFile = ../../secrets/noctalia-storage-key.age;
    owner = username;
    mode = "0400";
  };

  boot.tmp.useTmpfs = lib.mkForce false;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
    priority = 100;
  };

  hardware.enableRedistributableFirmware = true;

  jovian.steam.desktopSession = "niri";

  services = {
    # Jovian owns SDDM autologin and the game/desktop session handoff on this host.
    greetd.enable = lib.mkForce false;

    power-profiles-daemon.enable = true;
    upower = {
      enable = true;
      # Keep low-battery protection active in Niri too, not just in Steam's UI.
      criticalPowerAction = lib.mkForce "HybridSleep";
      allowRiskyCriticalPowerAction = lib.mkForce false;
    };
    fwupd.enable = true;

    # Jovian's InputPlumber owns the Ally's control devices; keep Kanata
    # away from them and its virtual keyboard when an external keyboard reconnects.
    kanata.keyboards.internal.extraDefCfg = lib.mkForce ''
      process-unmapped-keys yes
      linux-dev-names-exclude (
        "InputPlumber Keyboard"
        "LogiOps Virtual Input"
        "ASUSTeK Computer Inc. N-KEY Device"
      )
    '';
  };

  # SteamOS Manager supports the Ally's charge limit. Do not reset UI changes
  # to a fixed threshold on boot/resume or expose a second charge-limit tool.
  systemd.services.battery-charge-threshold.enable = false;
  hardware.asus.battery.enableChargeUptoScript = false;

  environment.systemPackages = with pkgs; [
    wvkbd
    wlr-randr
    brightnessctl
    playerctl
    powertop
    lm_sensors
    usbutils
    pciutils
  ];

  my = {
    niri = {
      gaps = 0;
      rounding = 0;
      border = {
        width = 1;
        color = "#a9b1d6";
        inactiveColor = "#16161e";
        urgentColor = "#ff3f7f";
      };
    };

    display.outputs = {
      "eDP-1" = {
        primary = true;
        width = 1920;
        height = 1080;
        refresh = 59.999;
        scale = 1.0;
        vrr = true;
        position = {
          x = 0;
          y = 0;
        };
      };
      "DP-2" = {
        enable = true;
        primary = false;
        width = 3840;
        height = 2160;
        refresh = 120.0;
        customMode = true;
        maxBpc = 10;
        scale = 1.0;
        vrr = true;
        position = {
          x = builtins.floor (edp1.width / edp1.scale);
          y = 0;
        };
      };
    };
    wallpaper.image = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/ly/wallhaven-lyje9y.png";
      hash = "sha256-HfFfdim6S7KLhB2T7YT6b1RawA0tmaPGxk4QF27PB8o=";
    };
    ui.scale = 2.0;
  };
}
