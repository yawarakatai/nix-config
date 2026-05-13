{ pkgs, ... }:

{
  imports = [
    (import ../../features/storage/disko-btrfs.nix {
      device = "/dev/disk/by-id/wwn-0x5001b448b61d211b";
    })
    ./hardware-configuration.nix

    ../../features/hardware/gpu/amd.nix
    ../../features/gaming
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Tmp on tmpfs for better performance
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "50%";
  };

  # --- Application and Service Settings ---;
  environment.sessionVariables = {
    __GL_SHADER_DISK_CACHE = "1";
    __GL_THREADED_OPTIMIZATION = "1";
  };

  # --- My Options ---

  my = {
    system.monitors.primary = {
      name = "DP-1";
      width = 3840;
      height = 2160;
      refresh = 59.997;
      scale = 1.5;
      vrr = true;
    };
  };

  # --- State Version ---
  system.stateVersion = "25.05";
}
