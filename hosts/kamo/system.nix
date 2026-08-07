{
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
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
        primary = true;
        width = 1920;
        height = 1080;
        refresh = 59.999;
        scale = 1.0;
        vrr = true;
      };
      "DP-2" = {
        enable = false;
      };
    };
    wallpaper.image = pkgs.fetchurl {
      url = "https://github.com/dharmx/walls/blob/main/abstract/a_blue_and_orange_background.jpg?raw=true";
      hash = "sha256-pqjk+zuSAcvTYHF7uPnf+2uIFg4l7Waz6fGzOUVDwFI=";
    };
    ui.scale = 2.0;
  };
}
