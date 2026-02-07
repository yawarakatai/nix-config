{ ... }:

{
  imports = [
    ../../modules/home/cli/core.nix
    ../../modules/home/cli/monitor.nix
    ../../modules/home/cli/file-manager.nix

    ../../modules/home/editor/helix.nix

    ../../modules/home/dev/git.nix
    ../../modules/home/dev/direnv.nix
  ];

  home.username = "yawarakatai";
  home.homeDirectory = "/home/yawarakatai";

  programs.home-manager.enable = true;
  programs.helix.settings.theme = "rose_pine";

  home.stateVersion = "25.05";
}
