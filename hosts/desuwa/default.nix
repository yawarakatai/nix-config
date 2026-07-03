{ pkgs, ... }:

{
  imports = [
    (import ../../features/storage/disko-btrfs.nix {
      device = "/dev/disk/by-id/nvme-Predator_SSD_GM7_M.2_2TB_PSBH53340306970";
    })
    ./hardware-configuration.nix

    # Hardware-specific modules
    ../../features/hardware/gpu/nvidia.nix # NVIDIA RTX 3080
    ../../features/security/gsr-kms-server.nix
    ../../features/input/mouse/logiops.nix # Logitech mouse
    ../../features/input/keyboard/lofree.nix # Lofree Flow keyboard
    ../../features/service/udev.nix

    ../../features/service
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Tmp on tmpfs for better performance
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "50%";
  };

  services.flatpak.enable = true;

  # --- Application and Service Settings ---;
  environment.sessionVariables = {
    __GL_SHADER_DISK_CACHE = "1";
    __GL_THREADED_OPTIMIZATION = "1";
  };

  # Restrict kanata to physical keyboard only (avoid intercepting logid Virtual Input)
  services.kanata.keyboards.internal.devices = [
    "/dev/input/by-id/usb-CX_2.4G_Wireless_Receiver-event-kbd"
  ];

  # --- My Options ---
  my = {
    system.monitors.primary = (import ../../displays).innocn-32m2v;
  };
}
