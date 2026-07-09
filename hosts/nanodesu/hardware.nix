{ inputs, ... }:

{
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
    ../../modules/input/touchpad.nix
    ../../modules/hardware/bluetooth.nix
    ../../modules/laptop/fingerprint.nix
    ../../modules/laptop/power.nix
    ../../modules/hardware/webcam.nix
  ];
}
