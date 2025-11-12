# IMPORTANT: This is a TEMPLATE file!
# You MUST regenerate this file on the actual hardware by running:
#   sudo nixos-generate-config --show-hardware-config > hosts/nanodesu/hardware-configuration.nix
#
# This template provides the expected structure with Btrfs subvolumes,
# but the UUIDs and specific hardware details will be different on your system.

{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # Kernel modules for ThinkPad X1 Nano Gen 2 (Intel 12th Gen)
  # These will be auto-detected by nixos-generate-config
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];  # Intel CPU
  boot.extraModulePackages = [ ];

  # Btrfs filesystem structure with subvolumes
  # REPLACE THE UUID WITH YOUR ACTUAL UUID FROM: sudo blkid /dev/nvme0n1p2
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-ROOT-UUID";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-ROOT-UUID";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-ROOT-UUID";
      fsType = "btrfs";
      options = [ "subvol=@nix" ];
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-ROOT-UUID";
      fsType = "btrfs";
      options = [ "subvol=@log" ];
    };

  fileSystems."/var/cache" =
    { device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-ROOT-UUID";
      fsType = "btrfs";
      options = [ "subvol=@cache" ];
    };

  fileSystems."/tmp" =
    { device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-ROOT-UUID";
      fsType = "btrfs";
      options = [ "subvol=@tmp" ];
    };

  # EFI boot partition
  # REPLACE THE UUID WITH YOUR ACTUAL BOOT UUID FROM: sudo blkid /dev/nvme0n1p1
  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-BOOT-UUID";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  # No swap device (using zram instead)
  swapDevices = [ ];

  # Network configuration
  networking.useDHCP = lib.mkDefault true;
  # Wireless interface will be auto-detected (typically wlp0s20f3 or similar)

  # Platform and CPU microcode
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
