{ config, pkgs, ... }:
{
  services.udev.packages = [ pkgs.platformio-core.udev ];

  users.users.${config.my.user.name}.extraGroups = [ "dialout" ];
}
