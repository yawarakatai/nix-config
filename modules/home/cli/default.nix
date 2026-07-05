{ pkgs, ... }:
{
  imports = [
    ./television.nix
  ];

  programs.bat.enable = true;
  programs.bottom.enable = true;

  home.packages = with pkgs; [
    ripgrep
    fd
    eza
    television

    duf
    dust

    jq

    tokei
    glow
    fastfetch
  ];
}
