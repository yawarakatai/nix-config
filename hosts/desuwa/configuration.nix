{ ... }:

{
  imports = [
    # Shared base configuration (common settings for all hosts)
    ../../modules/system

    # Hardware-specific modules for this host
    ../../modules/system/hardware/gpu/nvidia.nix # NVIDIA RTX 3080
    ../../modules/system/input/mouse/logiops.nix # Logitech mouse
    ../../modules/system/input/keyboard/lofree.nix # Lofree Flow keyboard
    ../../modules/system/gaming # Steam
  ];

  services.flatpak.enable = true;

  virtualisation.docker.enable = false;

  environment.sessionVariables = {
    __GL_SHADER_DISK_CACHE = "1";
    __GL_THREADED_OPTIMIZATION = "1";
  };

  # Tmp on tmpfs for better performance
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "50%";
  };

  # State version - DO NOT CHANGE after initial install
  system.stateVersion = "25.05";
}
