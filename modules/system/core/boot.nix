{ ... }:

{
  # Bootloader configuration
  boot = {
    initrd.systemd.enable = true;

    # Kernel parameters
    kernelParams = [
      "quiet"
      "splash"
      "nowatchdog"
      "mitigations=auto"
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
  };
}
