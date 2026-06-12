# ROCK 5T Headless Server — hostname "dane"
{ config, lib, pkgs, ... }:

{
  networking.hostName = lib.mkForce "dane";

  imports = [
    ./disko.nix
  ];

  # SD card FAT partition as /boot (extlinux)
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/FIRMWARE";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  boot = {
    # Override systemd-boot from server profile — use extlinux
    loader = {
      grub.enable = lib.mkForce false;
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = lib.mkForce false;
      generic-extlinux-compatible.enable = lib.mkForce true;
    };

    # Board-specific kernel params
    kernelParams = lib.mkForce [
      "rootwait"
      "rw"
      "earlycon"
      "consoleblank=0"
      "coherent_pool=2M"
      "irqchip.gicv3_pseudo_nmi=0"
      "console=ttyS2,1500000n8"
    ];
  };

  system.stateVersion = "25.05";
}
