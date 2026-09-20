{ config, pkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  # Prevent the in-tree drivers from claiming the GPU before the proprietary
  # userspace stack and NVIDIA open kernel modules are available.
  boot.blacklistedKernelModules = [
    "nouveau"
    "nova"
  ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [ pkgs.nvidia-vaapi-driver ];
    };

    nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  environment.sessionVariables.LIBVA_DRIVER_NAME = "nvidia";
}
