{ config, pkgs, lib, ... }:

{
  programs.obs-studio = {
    enable = true;

    plugins = with pkgs.obs-studio-plugins; [
      # PipeWire audio capture (for desktop audio)
      obs-pipewire-audio-capture

      # Additional useful plugins
      obs-vkcapture # Vulkan/OpenGL game capture
    ];
  };

  # Ensure NVENC libraries are available at runtime
  home.packages = with pkgs; [
    libva-utils # For verifying hardware acceleration with vainfo
    nvidia-vaapi-driver # NVIDIA VA-API driver
  ];

  # Set environment variables for hardware acceleration
  home.sessionVariables = {
    # Ensure OBS and other apps use NVIDIA for encoding/decoding
    LIBVA_DRIVER_NAME = "nvidia";
    # Point to NVIDIA VDPAU driver
    VDPAU_DRIVER = "nvidia";

    OBS_USE_EGL = "1";
  };

  # NOTE: Screen capture on niri + Wayland works through xdg-desktop-portal-gnome
  # configured in modules/system/wayland.nix
  #
  # KNOWN ISSUE: Wayland output with dmabuf may crash with NVIDIA drivers
  # due to known compatibility issues between OBS, NVIDIA, and Wayland dmabuf.
  # Workaround: Use "Automatic" or "OpenGL" output method in OBS settings instead of dmabuf.
}
