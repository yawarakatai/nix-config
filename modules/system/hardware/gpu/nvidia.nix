{ config, pkgs, ... }:

{
  # NVIDIA driver configuration
  services.xserver.videoDrivers = [ "nvidia" ];

  # Blacklist nouveau completely
  boot.blacklistedKernelModules = [
    "nouveau"
    "nova"
  ];

  boot.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];

  hardware = {
    # Enable OpenGL
    graphics = {
      enable = true;
      enable32Bit = true;

      # Include NVIDIA CUDA libraries for hardware encoding (NVENC)
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        cudaPackages.cuda_cudart
      ];
    };

    # NVIDIA settings
    nvidia = {
      # Modesetting required for Wayland
      modesetting.enable = true;

      # Power management (experimental)
      powerManagement = {
        enable = false;
        finegrained = false;
      };

      # Open source kernel module (experimental, use false for proprietary)
      open = false;

      # Enable nvidia-settings menu
      nvidiaSettings = true;

      # Driver package
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  # Environment variables for Wayland + NVIDIA
  environment.sessionVariables = {
    # NVIDIA Wayland support
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";

    # Wayland fixes
    WLR_NO_HARDWARE_CURSORS = "1";

    # NVIDIA-specific Wayland variables
    __GL_GSYNC_ALLOWED = "1";
    __GL_VRR_ALLOWED = "1";
  };

  # Kernel parameters for NVIDIA
  boot.kernelParams = [ ];

}
