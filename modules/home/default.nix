# Common home configuration
# Shared packages, XDG settings, and environment variables
{ config, pkgs, ... }:

{
  # Common packages used across all home configurations
  # These are everyday utilities that every user profile should have
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

  # Environment variables
  systemd.user.sessionVariables = {
    XMODIFIERS = "@im=fcitx";
    QT_IM_MODULE = "wayland;fcitx";

    EDITOR = "hx";
    VISUAL = "hx";
    PAGER = "cat";
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
}
