{ pkgs, vars, ... }:

let
  theme = import ../../modules/home/themes/under-construction.nix { inherit vars; };
in
{
  # Make theme available to all modules
  _module.args.theme = theme;

  # Minimal server configuration - no desktop/wayland modules
  imports = [
    # Essential tools only
    ../../modules/home/editors/helix.nix
    ../../modules/home/shell/nushell.nix
    ../../modules/home/shell/starship.nix
    ../../modules/home/tools/cli-tools.nix
  ];

  # User settings
  home.username = vars.username;
  home.homeDirectory = "/home/${vars.username}";

  # Minimal package set for server
  home.packages = with pkgs; [
    # System tools
    htop
    btop
    tree
    ripgrep
    fd

    # Network tools
    wget
    curl

    # Archive tools
    unzip
    zip
  ];

  # Environment variables
  systemd.user.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
    PAGER = "less";
  };

  # Git configuration
  programs.git = {
    enable = true;
    settings = {
      user =
        {
          name = vars.gitName;
          email = vars.gitEmail;
        };
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = false;
        core.editor = "hx";
      };
    };
  };

  # direnv for development
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableNushellIntegration = true;
  };

  # XDG configuration
  xdg.enable = true;

  # State version
  home.stateVersion = "25.05";
}
