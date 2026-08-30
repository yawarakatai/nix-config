{ inputs, pkgs, ... }:

{
  home.packages = [
    inputs.plainix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
