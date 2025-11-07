{ config, pkgs, vars, ... }:

{
  # PipeWire audio configuration
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;

    # ALSA support
    alsa = {
      enable = true;
      support32Bit = true;
    };

    # PulseAudio compatibility
    pulse.enable = true;

    # JACK support (for professional audio)
    jack.enable = true;
  };

  # Disable PulseAudio (using PipeWire instead)
  services.pulseaudio.enable = false;
}
