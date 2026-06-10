{ pkgs, ... }:
{
  imports = [
    ./zellij.nix
  ];

  home.packages = with pkgs; [
    ripgrep
    fd
    bat
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
