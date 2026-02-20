{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix

    # Hardware-specific modules
    ../../modules/system/hardware/gpu/nvidia.nix # NVIDIA RTX 3080
    ../../modules/system/input/mouse/logiops.nix # Logitech mouse
    ../../modules/system/input/keyboard/lofree.nix # Lofree Flow keyboard

    ../../modules/system/gaming # Steam
    ../../modules/system/service/udev.nix # Udev
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Custom kernel for gaming
  # Chaotic nyx must be installed
  # boot.kernelPackages = pkgs.linuxPackages_cachyos-lto;

  # services.scx = {
  #   enable = true;
  #   scheduler = "scx_rustland";
  # };

  # Tmp on tmpfs for better performance
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "50%";
  };

  # --- Application and Service Settings ---;
  services.flatpak.enable = true;
  virtualisation.docker.enable = false;

  environment.sessionVariables = {
    __GL_SHADER_DISK_CACHE = "1";
    __GL_THREADED_OPTIMIZATION = "1";
  };

  # --- My Options ---

  my = {
    system.monitors.primary = {
      name = "HDMI-A-1";
      width = 3840;
      height = 2160;
      refresh = 119.880;
      vrr = true;
    };
  };

  # --- State Version ---
  # State version - DO NOT CHANGE after initial install
  system.stateVersion = "25.05";
}
