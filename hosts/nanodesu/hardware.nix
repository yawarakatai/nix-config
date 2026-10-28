{
  imports = [
    ../../modules/laptop/fingerprint.nix
  ];

  # Audio and Bluetooth are unused on this host.
  disabledModules = [
    ../../modules/hardware/audio.nix
    ../../modules/hardware/bluetooth.nix
  ];

  # Keep PipeWire for screen sharing without running it as a sound server.
  services.pipewire = {
    enable = true;
    audio.enable = false;
    alsa.enable = false;
    pulse.enable = false;
  };
}
