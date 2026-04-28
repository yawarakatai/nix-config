{ config, pkgs, ... }:
{
  services.udev.packages = [ pkgs.platformio-core.udev ];

  users.users.${config.my.user.name}.extraGroups = [ "dialout" ];

  services.udev.extraRules = ''
    KERNEL=="ttyACM[0-9]*", MODE="0666"
  '';
}
