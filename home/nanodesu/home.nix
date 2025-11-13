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
    # Niri compositor
    inputs.niri.homeModules.niri

    # Vicinae Home Manager module
    inputs.vicinae.homeManagerModules.default

    # Anyrun Home Manager module
    inputs.anyrun.homeManagerModules.default

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
    ../../modules/home/terminal/alacritty.nix

    # Wayland
    ../../modules/home/wayland/wayland-packages.nix
    ../../modules/home/wayland/niri
    ../../modules/home/wayland/waybar.nix
    ../../modules/home/wayland/vicinae.nix
    ../../modules/home/wayland/anyrun.nix
    ../../modules/home/wayland/mako.nix

    # Tools
    ../../modules/home/tools/yazi.nix
    ../../modules/home/tools/lazygit.nix
    ../../modules/home/tools/cli-tools.nix

    # Themes
    ../../modules/home/themes/gtk-theme.nix
  ];

  home.sessionVariables = {
    XMODIFIERS = "@im=fcitx";
    QT_IM_MODULE = "wayland;fcitx";

    EDITOR = "hx";
    VISUAL = "hx";
    PAGER = "bat";
  };

  programs.niri.enable = true;

  # User packages
  home.packages = with pkgs; [
    # System info
    neofetch
    htop
    tree

    # File manager
    nautilus

    # Image viewer
    imv

    # Markdown reader
    glow

    # Media and system controls
    pavucontrol # PulseAudio volume control GUI
    playerctl # Media player controls
    brightnessctl # Brightness controls
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

      # Point all directories to home to prevent creation of unwanted directories
      desktop = "${config.home.homeDirectory}";
      documents = "${config.home.homeDirectory}";
      download = "${config.home.homeDirectory}"; # Downloads go directly to home
      music = "${config.home.homeDirectory}";
      pictures = "${config.home.homeDirectory}";
      videos = "${config.home.homeDirectory}";
      templates = "${config.home.homeDirectory}";
      publicShare = "${config.home.homeDirectory}";
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

  # State version - DO NOT CHANGE after initial install
  home.stateVersion = "25.05";
}
