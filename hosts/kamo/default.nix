{
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  disk = ./disk.nix;
  niriSession = "${config.programs.niri.package}/bin/niri-session";
in
{
  imports = [
    (import ../../modules/storage/disko-ext4.nix {
      inherit (disk) device;
    })

    ./hardware-configuration.nix
  ];

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
    system.monitors.primary = {
      name = "eDP-1";
      width = 1920;
      height = 1080;
      refresh = 120.0;
      scale = 1.0;
      vrr = true;
    };

    ui = {
      scale = 1.25;

      bar = {
        position = "bottom";
        thicknessRatio = 0.026;
        minThickness = 28;
        maxThickness = 36;
        padding = 8;
        marginEndsRatio = 0.16;
        maxMarginEnds = 320;
      };
    };
  };
}
