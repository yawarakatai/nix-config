{ config, pkgs, vars, ... }:

{
  # Enable all firmware (needed for modern Intel audio - SOF firmware)
  hardware.enableAllFirmware = true;

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

  # Additional packages for audio troubleshooting
  environment.systemPackages = with pkgs; [
    pavucontrol # PulseAudio/PipeWire volume control
    alsa-utils # ALSA utilities (aplay, arecord, etc.)
  ];
}
