{ inputs, ... }:

{
  imports = [
    inputs.disko.nixosModules.disko
    ../../core
    ../../storage
  ];
}
