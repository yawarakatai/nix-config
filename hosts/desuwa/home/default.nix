{ pkgs, ... }:

{
  home.packages = with pkgs; [
    godot
    orca-slicer
  ];

  imports = [
    ../../../modules/profiles/home/desktop.nix
    ../../../modules/home/creative/pixelorama.nix
    ../../../modules/home/services/ura.nix
  ];
}
