{ pkgs, ... }:
{
  imports = [
    ./zellij.nix
    ./television.nix
  ];

  programs.bat.enable = true;

  home.packages = with pkgs; [
    ripgrep
    fd
    eza
    erdtree
    television

    duf
    dust

    bottom

    jq

    zellij
    croc
    tokei
    glow
    fastfetch
  ];

  programs.bottom = {
    enable = true;
    settings = {
      flags = {
        color = "default";
        mem_as_value = true;
        tree = true;
      };
    };
  };
}
