# Creative tools for game development, 3D modeling, PCB design, and video editing
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Game Development
    godot

    # 3D modeling
    blender

    # PCB design
    kicad
  ];
}
