{ config, osConfig, ... }:

{
  imports = [
    ../cli
    ../dev
    ../editor/helix.nix
    ../service/syncthing.nix
    ../shell
  ];

  home.username = osConfig.my.user.name;
  home.homeDirectory = "/home/${osConfig.my.user.name}";

  home.stateVersion = "25.05";

  # Create symlink of nix-config
  home.file."nix-config" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-config";
  };

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

      # Explicitly set to maintain current behavior (changed in HM 26.05)
      setSessionVariables = true;

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
  };
}
