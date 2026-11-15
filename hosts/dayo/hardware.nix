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

    # The onboard RTL8852BE Wi-Fi lacks Japanese radio certification; keep it from transmitting
    # even if the firmware's devicetree, which leaves its slot on, is ever booted.
    blacklistedKernelModules = [
      "rtw89_8852be"
      "rtw89_8852b"
      "rtw89_pci"
      "rtw89_core"
    ];

    # Boot with the kernel's DTB instead of the one the UEFI firmware embeds, so the overlay applies.
    loader.systemd-boot.installDeviceTree = true;
  };

  # Switch the unused Wi-Fi slot off. Its 3.3 V supply is marked always-on and
  # overlays cannot delete properties, so disable the regulator and hold its enable pin low.
  hardware.deviceTree = {
    name = "rockchip/rk3588-rock-5t.dtb";
    filter = "rk3588-rock-5t.dtb";
    overlays = [
      {
        name = "wifi-slot-off";
        dtsText = ''
          /dts-v1/;
          /plugin/;

          #include <dt-bindings/gpio/gpio.h>
          #include <dt-bindings/pinctrl/rockchip.h>

          / {
            compatible = "radxa,rock-5t";
          };

          &pcie2x1l0 {
            status = "disabled";
          };

          &vcc3v3_pcie2x1l0 {
            status = "disabled";
          };

          &gpio2 {
            wifi-slot-power-hog {
              gpio-hog;
              gpios = <RK_PC0 GPIO_ACTIVE_HIGH>;
              output-low;
              line-name = "vcc3v3_pcie2x1l0_en";
            };
          };
        '';
      }
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
