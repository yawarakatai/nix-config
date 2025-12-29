{ vars, inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-nano

    # Shared base configuration (common settings for all hosts)
    ../../modules/system

    # Laptop-specific hardware modules
    ../../modules/system/input/touchpad.nix # Touchpad with natural scrolling, tap-to-click
    ../../modules/system/hardware/bluetooth.nix # Bluetooth support
    ../../modules/system/laptop/fingerprint.nix # Fingerprint reader for login/sudo
    ../../modules/system/laptop/power.nix # TLP power management for battery optimization
    ../../modules/system/hardware/webcam.nix # Webcam support
    ../../modules/system/input/keyboard/kanata.nix # Specified key layout remap
  ];

  # Workaround for Alder Lake audio firmware signature verification failure
  # Use legacy HDA driver instead of SOF until firmware is properly signed
  # dsp_driver: 1=legacy HDA, 3=SOF (Smart Sound)
  boot.kernelParams = [
    "snd_intel_dspcfg.dsp_driver=1"
  ];

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchDocked = "suspend";
    HandleLidSwitchExternalPower = "suspend";
  };

  # State version - DO NOT CHANGE after initial install
  system.stateVersion = "25.05";
}
