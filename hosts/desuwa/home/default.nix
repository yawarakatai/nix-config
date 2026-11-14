{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bottles
    orca-slicer
  ];

  imports = [
    ../../../modules/profiles/home/desktop.nix
    ../../../modules/home/creative/pixelorama.nix
    ../../../modules/home/services/ura.nix
    ../../../modules/gaming/home.nix
  ];
}
