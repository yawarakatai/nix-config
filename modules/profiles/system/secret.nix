{ inputs, ... }:

{
  imports = [
    ./base.nix
    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default
    ../../security
    ../../services/openssh.nix
  ];
}
