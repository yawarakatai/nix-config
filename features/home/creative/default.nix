{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # # Game Development
    godot

    pixelorama

    # # 3D modeling
    # blender
    orca-slicer

    # # PCB design
    # kicad
  ];
}
