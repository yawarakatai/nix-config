{ inputs, pkgs, ... }:

{
  home.packages = [
    inputs.firn.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
