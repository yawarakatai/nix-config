{ inputs, pkgs, ... }:

let
  madoriLib = import ../../lib/madori.nix;
in
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
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

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

  # --- My Options ---
  my = {
    system.monitors.primary = (import ../../displays).innocn-32m2v;
  };

  services.madori = {
    enable = true;
    package = inputs.madori.packages.x86_64-linux.default;

    monitors.innocn = madoriLib.mkMonitor "HDMI-A-1" 1.0;

    rules = [
      (madoriLib.only "innocn")
      (madoriLib.virtual 3840 2160 120)
    ];
  };

  # --- State Version ---
  # State version - DO NOT CHANGE after initial install
  system.stateVersion = "25.05";
}
