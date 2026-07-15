{ inputs, lib, ... }:

{
  imports = [
    inputs.nixos-rock5t.nixosModules.rock5t
    inputs.nixos-rock5t.nixosModules.ubootExtlinux
  ];

  boot = {
    kernelParams = [ "pcie_aspm=force" ];

    loader.efi.canTouchEfiVariables = lib.mkForce false;

    blacklistedKernelModules = [
      "rtw89_8852be"
      "rtw89_8852b"
      "rtk_btusb"
      "btusb"
    ];
  };
}
