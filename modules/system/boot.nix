{ config, lib, pkgs, vars, ... }:

{
  # Bootloader configuration
  boot = {
    # Use latest kernel
    kernelPackages = pkgs.linuxPackages_zen;

    # Kernel parameters
    kernelParams = [
      "quiet"
      "splash"
    ];

    # Boot loader
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
        consoleMode = "auto";
        editor = false; # Disable editor for security
      };

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };

      timeout = 3;
    };

    # Plymouth for boot splash (optional)
    plymouth = {
      enable = false; # Set to true if you want boot splash
    };

    # Tmp on tmpfs for better performance
    tmp = {
      useTmpfs = true;
      tmpfsSize = "50%";
    };
  };
}
