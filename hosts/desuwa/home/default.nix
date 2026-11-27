{ pkgs, ... }:

{
  home.packages = [ pkgs.orca-slicer ];

  imports = [
    ../../../modules/profiles/home/desktop.nix
    ../../../modules/home/creative/godot.nix
    ../../../modules/home/creative/pixelorama.nix
    ../../../modules/home/services/ura.nix
  ];
}
