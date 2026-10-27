_:

{
  # Bluetooth configuration
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true; # Enable experimental features like battery level
      };
    };
  };

  # Bluetooth manager service
  services.blueman.enable = true;
}
