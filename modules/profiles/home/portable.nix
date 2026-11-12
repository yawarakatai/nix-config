{ ... }:

{
  imports = [
    ../../home/cli
    ../../home/editor/helix.nix
    ../../home/dev
  ];

  programs.home-manager.enable = true;

  # Home Manager's Bash files load the session variables below on non-NixOS hosts.
  programs.bash.enable = true;

  targets.genericLinux = {
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
