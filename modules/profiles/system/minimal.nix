{ inputs, ... }:

{
  imports = [
    inputs.disko.nixosModules.disko
    ../../core/boot.nix
    ../../core/locale.nix
    ../../core/networking.nix
    ../../core/nix.nix
    ../../core/packages.nix
    ../../storage/zram.nix
    ../../services/openssh.nix
  ];
}
