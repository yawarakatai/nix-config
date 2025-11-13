{ config, pkgs, vars, ... }:

{
  # Enable all firmware (needed for modern Intel audio - SOF firmware)
  hardware.enableAllFirmware = true;

  # Explicitly include SOF firmware for modern Intel audio
  hardware.firmware = with pkgs; [
    linux-firmware
    sof-firmware
  ];

  # Enable sound support
  services.pulseaudio.enable = false;

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

    # WirePlumber for session management (modern replacement for pipewire-media-session)
    wireplumber.enable = true;
  };

  # Additional packages for audio troubleshooting
  environment.systemPackages = with pkgs; [
    pavucontrol # PulseAudio/PipeWire volume control
    alsa-utils # ALSA utilities (aplay, arecord, etc.)
    wireplumber # WirePlumber utilities
    pipewire # PipeWire utilities (pw-cli, pw-top, etc.)
  ];
}
