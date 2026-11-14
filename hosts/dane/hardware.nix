{ lib, pkgs, ... }:

{
  hardware.enableRedistributableFirmware = true;

  boot = {
    # A router favors fewer kernel regressions over new hardware support.
    kernelPackages = lib.mkForce pkgs.linuxPackages;

    # The debug UART is the way in when the network itself is broken.
    kernelParams = [
      "console=tty0"
      "console=ttyS2,1500000n8"
    ];

    # The onboard RTL8852BE Wi-Fi lacks Japanese radio certification; keep it from transmitting.
    blacklistedKernelModules = [
      "rtw89_8852be"
      "rtw89_8852b"
      "rtw89_pci"
      "rtw89_core"
    ];
  };

  # The blue status LED blinks a bright heartbeat; it is a GPIO LED, so it can only be switched off, not dimmed.
  # The green power LED is wired to the supply and cannot be controlled.
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="leds", KERNEL=="blue:status", ATTR{trigger}="none", ATTR{brightness}="0"
  '';

  # Reboot through the SoC's DesignWare watchdog if the system hangs.
  systemd.settings.Manager.RuntimeWatchdogSec = "30s";
}
