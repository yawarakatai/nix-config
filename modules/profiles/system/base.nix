{ inputs, ... }:

{
  imports = [
    inputs.disko.nixosModules.disko
    ../../core
    ../../storage
    ../../services/tailscale.nix
    ../../input/keyboard/kanata.nix
  ];
}
