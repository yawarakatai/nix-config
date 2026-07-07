{ pkgs, username, ... }:
{
  services.udev.packages = [ pkgs.platformio-core.udev ];

  users.users.${username}.extraGroups = [ "dialout" ];

  services.udev.extraRules = ''
    KERNEL=="ttyACM[0-9]*", MODE="0666"
  '';
}
