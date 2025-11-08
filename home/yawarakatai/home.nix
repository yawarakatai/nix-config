{ config, pkgs, vars, inputs, ... }:

let
  theme = import ../../modules/home/themes/night-neon.nix { inherit vars; };
in
{
  home.username = vars.username;
  home.homeDirectory = "/home/${vars.username}";

  # Make theme available to all modules
  _module.args.theme = theme;

  # Import all home modules
  imports = [
    # Shell
    ../../modules/home/shell/nushell.nix
    ../../modules/home/shell/starship.nix
    ../../modules/home/shell/zoxide.nix
    ../../modules/home/shell/atuin.nix

    # Editors
    ../../modules/home/editors/helix.nix
    ../../modules/home/editors/vscode.nix

    # Browsers
    ../../modules/home/browser/firefox.nix

    # Terminal
    ../../modules/home/terminal/ghostty.nix
    ../../modules/home/terminal/alacritty.nix
    ../../modules/home/terminal/kitty.nix

    # Wayland
    ../../modules/home/wayland/niri
    ../../modules/home/wayland/waybar.nix
    ../../modules/home/wayland/anyrun.nix
    ../../modules/home/wayland/mako.nix
    ../../modules/home/wayland/swaybg.nix

    # Tools
    ../../modules/home/tools/yazi.nix
    ../../modules/home/tools/lazygit.nix
    ../../modules/home/tools/cli-tools.nix
  ];

  # User packages
  home.packages = with pkgs; [
    # Browser
    # firefox

    # System info
    neofetch

    # File manager (GUI)
    nautilus
  ];


  # Git configuration
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = vars.gitName;
        email = vars.gitEmail;
      };

      init.defaultBranch = "main";
      pull.rebase = false;
      core.editor = "hx";

      # Delta for better diffs
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      delta = {
        navigate = true;
        light = false;
        line-numbers = true;
        syntax-theme = "base16";
      };

      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
  };


  # direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableNushellIntegration = true;
  };

  # XDG configuration
  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = false;

      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
      templates = "${config.home.homeDirectory}/Templates";
      publicShare = "${config.home.homeDirectory}/Public";
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
        "application/pdf" = "firefox.desktop";
        "image/*" = "imv.desktop";
        "video/*" = "mpv.desktop";
      };
    };
  };

  # GTK theme (optional)
  gtk = {
    enable = true;

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    theme = {
      name = "Colloid-Dark";
      package = pkgs.colloid-gtk-theme;
    };
    iconTheme = {
      name = "Colloid-Dark";
      package = pkgs.colloid-icon-theme;
    };
    # cursorTheme = {
    #   name = "Adwaita";
    #   package = pkgs.adwaita-icon-theme;
    # };
  };

  # State version - DO NOT CHANGE after initial install
  home.stateVersion = "25.05";
}
