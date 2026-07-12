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

    logind.settings.Login.HandlePowerKey = "ignore";
  };

  hardware.asus.battery.chargeUpto = 80;

  services.greetd.settings.initial_session = {
    command = niriSession;
    user = username;
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
    };
    wallpaper.image = pkgs.fetchurl {
      url = "https://i.redd.it/mg5w8i3gkstg1.jpeg";
      hash = "sha256-02EacG9i2c4puqQ5VRVPTBZmZDInA8pBC8QG9IMJEn8=";
    };
    ui.scale = 2.0;
  };
}
