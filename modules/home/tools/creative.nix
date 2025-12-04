{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    godot
    kicad
  ];
}
