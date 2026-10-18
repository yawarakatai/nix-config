{ pkgs, ... }:

{
  imports = [ ./pixelorama.nix ];

  home.packages = with pkgs; [
    godot
  ];
}
