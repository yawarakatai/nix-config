{ inputs, ... }:

{
  imports = [
    inputs.disko.nixosModules.disko
    ../../../lib/options.nix
    ../../core
    ../../storage
    ../../services/tailscale.nix
    ../../input/keyboard/kanata.nix
  ];
}
