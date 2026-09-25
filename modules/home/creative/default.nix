{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # # Game Development
    godot

    blender

    pixelorama

    # # 3D modeling
    # blender
    orca-slicer

    # # PCB design
    kicad

    kdePackages.kdenlive
  ];
}
