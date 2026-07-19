{ ... }:

{
  imports = [
    ../../home/cli
    ../../home/editor/helix.nix
    ../../home/shell
    ../../home/dev
  ];

  programs.home-manager.enable = true;

  targets.genericLinux.enable = true;

  xdg.enable = true;

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
    PAGER = "bat";
  };
}
