{ pkgs, ... }:

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
}
