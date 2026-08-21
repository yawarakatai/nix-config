{
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  edp1 = config.my.display.outputs."eDP-1";
  dp2 = config.my.display.outputs."DP-2";

  niriSession = "${config.programs.niri.package}/bin/niri-session";
in
{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.tmp.useTmpfs = lib.mkForce false;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
    priority = 100;
  };

  hardware.enableRedistributableFirmware = true;

  services = {
    power-profiles-daemon.enable = true;
    upower.enable = true;
    fwupd.enable = true;

  };

  hardware.asus.battery.chargeUpto = 80;

  services.greetd.settings.initial_session = {
    command = niriSession;
    user = username;
  };

  age.secrets.noctalia-storage-key = {
    rekeyFile = ../../secrets/noctalia-storage-key.age;
    owner = username;
    mode = "0400";
  };

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
    display.outputs = {
      "eDP-1" = {
        primary = false;
        width = 1920;
        height = 1080;
        refresh = 59.999;
        scale = 1.0;
        vrr = true;
        position = {
          x = builtins.floor ((dp2.width / dp2.scale - edp1.width / edp1.scale) / 2);
          y = builtins.floor (dp2.height / dp2.scale);
        };
      };
      "DP-2" = {
        enable = !edp1.primary;
        primary = !edp1.primary;
        width = 3840;
        height = 2160;
        refresh = 60.0;
        scale = 1.333;
        vrr = true;
        position = {
          x = 0;
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
