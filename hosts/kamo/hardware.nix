{ inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.asus-ally-rc71l
    ../../modules/input/mouse/logiops.nix
  ];
}
