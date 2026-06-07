# Creative tools for game development, 3D modeling, PCB design, and video editing
{ pkgs, ... }:

{
  imports = [
    ./gpu-screen-recorder.nix
  ];

  home.packages = with pkgs; [
    # # Game Development
    godot

    pixelorama

    # # 3D modeling
    # blender

    # # PCB design
    # kicad
  ];
}
