{ lib, ... }:

{
  # Bootloader configuration
  boot = {
    initrd = {
      verbose = false;
      systemd = {
        enable = true;
        contents."/etc/vconsole.conf".text = lib.mkForce "FONT=\n";
      };
    };

    # Keep routine boot messages from overwriting the greetd TTY.
    consoleLogLevel = 3;

    # Kernel parameters
    kernelParams = [
      "nowatchdog"
      "mitigations=auto"
      "quiet"
      "systemd.show_status=false"
      "rd.systemd.show_status=false"
      "udev.log_level=3"
      "rd.udev.log_level=3"
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
