{ lib, ... }:

{
  imports = [
    ./binds.nix
    ./settings.nix
    ./startups.nix
    ./window-rules.nix
  ];

  xdg.configFile."niri/blur.kdl".source = ./blur.kdl;

  # Inject include directive into generated niri config
  programs.niri.config = lib.mkOrder 1500 ''include "blur.kdl"'';
}
