{ osConfig, ... }:

{
  imports = [
    ../../modules/home/cli/core.nix
    ../../modules/home/cli/monitor.nix
    ../../modules/home/editor/helix.nix
    ../../modules/home/dev/git.nix
    ../../modules/home/dev/direnv.nix
  ];

  home.username = osConfig.my.user.name;
  home.homeDirectory = "/home/${osConfig.my.user.name}";

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}
