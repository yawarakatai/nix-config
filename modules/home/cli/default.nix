{ pkgs, ... }:
{
  imports = [
    ./television.nix
    ./wiremix.nix
    ./yazi.nix
  ];

  programs.bat.enable = true;
  programs.bottom.enable = true;

  home.packages = with pkgs; [
    ripgrep
    fd
    eza
    television
    wiremix

    duf
    dust

    jq

    tokei
    glow
    fastfetch
  ];
}
