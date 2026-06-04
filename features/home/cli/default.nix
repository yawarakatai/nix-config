{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ripgrep
    fd
    bat
    television

    duf
    dust

    bottom

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
