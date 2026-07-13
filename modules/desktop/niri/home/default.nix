{ pkgs, ... }:

{
  imports = [
    ./blur.nix
    ./binds.nix
    ./clipboard.nix
    ./settings.nix
    ./window-rules.nix
  ];

  home.packages = with pkgs; [
    wl-clipboard
    grim # Screenshot tool
    slurp # Area selector for screenshots
  ];
}
