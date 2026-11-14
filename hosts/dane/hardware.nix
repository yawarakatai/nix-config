_:

{
  hardware.enableRedistributableFirmware = true;

  # The onboard RTL8852BE Wi-Fi lacks Japanese radio certification; keep it from transmitting.
  boot.blacklistedKernelModules = [
    "rtw89_8852be"
    "rtw89_8852b"
    "rtw89_pci"
    "rtw89_core"
  ];
}
