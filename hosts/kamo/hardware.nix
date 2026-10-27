{ inputs, ... }:

{
  # Also enables Jovian's backlight access rule for the Steam brightness slider.
  jovian.hardware.has.amd.gpu = true;

  imports = [
    inputs.nixos-hardware.nixosModules.asus-ally-rc71l
    ../../modules/input/mouse/logiops.nix
    ../../modules/input/keyboard/lofree.nix
  ];
}
