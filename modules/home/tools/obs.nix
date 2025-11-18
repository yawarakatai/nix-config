{ config, pkgs, lib, ... }:

let
  # Build FFmpeg with full NVENC support for NVIDIA hardware encoding
  ffmpeg-nvenc = (pkgs.ffmpeg-full.override {
    withNvenc = true; # Enable NVIDIA hardware encoding
  }).overrideAttrs (old: {
    # Ensure nv-codec-headers is available for NVENC
    buildInputs = (old.buildInputs or []) ++ [ pkgs.nv-codec-headers-12 ];
  });

  # Override OBS Studio to use our NVENC-enabled FFmpeg
  obs-with-nvenc = pkgs.obs-studio.override {
    ffmpeg = ffmpeg-nvenc;
  };
in
{
  programs.obs-studio = {
    enable = true;
    package = obs-with-nvenc;

    plugins = with pkgs.obs-studio-plugins; [
      # PipeWire audio capture (for desktop audio)
      obs-pipewire-audio-capture

      # Additional useful plugins
      obs-vkcapture  # Vulkan/OpenGL game capture
    ];
  };

  # Ensure NVENC libraries are available at runtime
  home.packages = with pkgs; [
    libva-utils  # For verifying hardware acceleration with vainfo
    nvidia-vaapi-driver  # NVIDIA VA-API driver
  ];

  # Set environment variables for hardware acceleration
  home.sessionVariables = {
    # Ensure OBS and other apps use NVIDIA for encoding/decoding
    LIBVA_DRIVER_NAME = "nvidia";
    # Point to NVIDIA VDPAU driver
    VDPAU_DRIVER = "nvidia";
  };

  # NOTE: Screen capture on niri + Wayland works through xdg-desktop-portal-gnome
  # configured in modules/system/wayland.nix
  #
  # KNOWN ISSUE: Wayland output with dmabuf may crash with NVIDIA drivers
  # due to known compatibility issues between OBS, NVIDIA, and Wayland dmabuf.
  # Workaround: Use "Automatic" or "OpenGL" output method in OBS settings instead of dmabuf.
}
