{ inputs, pkgs, ... }:

{
  home.packages = [
    inputs.ura.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
