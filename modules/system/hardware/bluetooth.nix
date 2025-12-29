{ config, pkgs, vars, ... }:

{
  # Bluetooth configuration
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true; # Enable experimental features like battery level
      };
    };
  };

  # Bluetooth manager service
  services.blueman.enable = true;
}
