{ ... }:

{
  imports = [
    ../../home/cli
    ../../home/editor/helix.nix
    ../../home/shell
    ../../home/dev
    ../../home/services/ssh-client.nix
  ];

  programs.home-manager.enable = true;

  targets.genericLinux.enable = {
    enable = true;
    gpu.enable = false;
  };

  xdg.enable = true;

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
    PAGER = "bat";
  };
}
