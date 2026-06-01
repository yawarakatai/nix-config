{ lib, ... }:

{
  imports = [
    ./binds.nix
    ./settings.nix
    ./startups.nix
    ./window-rules.nix
  ];

  programs.niri.config = lib.mkOrder 1500 ''
    window-rule {
        match app-id="^Alacritty$"
        background-effect { blur true }
    }
    window-rule {
        match app-id="^floating-term$"
        background-effect { blur true }
    }
  '';
}
