{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ripgrep
    television

    duf
    dust

    bottom

    zellij
    croc
    tokei
    glow
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
