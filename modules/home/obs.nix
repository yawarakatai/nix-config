{ config, pkgs, lib, ... }:

{
  programs.obs-studio = {
    enable = true;

    # Override OBS to enable NVENC hardware encoding support
    package = pkgs.obs-studio.overrideAttrs (old: {
      # Enable NVENC support via CUDA
      cmakeFlags = (old.cmakeFlags or []) ++ [
        "-DENABLE_NVENC=ON"
      ];

      buildInputs = old.buildInputs ++ [
        pkgs.cudatoolkit
        pkgs.nv-codec-headers
      ];
    });

    plugins = with pkgs.obs-studio-plugins; [
      # Wayland screen capture support
      wlrobs

      # PipeWire audio capture (for desktop audio)
      obs-pipewire-audio-capture

      # Additional useful plugins
      obs-vkcapture  # Vulkan/OpenGL game capture
    ];
  };

  # Ensure NVENC libraries are available
  home.packages = with pkgs; [
    cudatoolkit
    libva-utils  # For verifying hardware acceleration
  ];

  # Set environment variables for hardware acceleration
  home.sessionVariables = {
    # Ensure OBS uses NVIDIA for encoding
    LIBVA_DRIVER_NAME = "nvidia";
  };
}
