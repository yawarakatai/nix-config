{ inputs, ... }:

{
  imports = [
    inputs.nixos-rock5t.nixosModules.rock5t
  ];
}
