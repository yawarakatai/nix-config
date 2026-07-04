{ pkgs, ... }:
{
  imports = [
    ./television.nix
  ];

  programs.bat.enable = true;

  home.packages = with pkgs; [
    ripgrep
    fd
    eza
    television

    duf
    dust

    jq
    btop

    tokei
    glow
    fastfetch
  ];
}
