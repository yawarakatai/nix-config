{ lib, ... }:

{
  imports = [
    ./disko.nix
  ];

  fileSystems = lib.mkForce {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
    "/data" = {
      device = "/dev/disk/by-id/nvme-BC711_NVMe_SK_hynix_256GB____CDA3N81581070463W-part1";
      fsType = "ext4";
    };
    "/storage" = {
      device = "/dev/disk/by-id/nvme-WD_BLACK_SN770_1TB_22134E800783-part1";
      fsType = "ext4";
    };
  };

  boot = {
    loader = {
      grub.enable = lib.mkForce false;
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = lib.mkForce false;
      generic-extlinux-compatible.enable = lib.mkForce true;
    };

    kernelParams = lib.mkForce [
      "rootwait"
      "rw"
      "earlycon"
      "consoleblank=0"
      "coherent_pool=2M"
      "irqchip.gicv3_pseudo_nmi=0"
      "root=fstab"
      "pcie_aspm=force"
      "console=ttyS2,1500000n8"
    ];

    blacklistedKernelModules = [
      "rtw89_8852be"
      "rtw89_8852b"
      "rtk_btusb"
      "btusb"
    ];
  };
}
