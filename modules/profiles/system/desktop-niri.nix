{ inputs, ... }:

{
  imports = [
    ./desktop.nix
    inputs.niri.nixosModules.niri
    ../../desktop/niri/system.nix
  ];
}
