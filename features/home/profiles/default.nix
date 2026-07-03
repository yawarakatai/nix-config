{
  config,
  osConfig,
  self,
  ...
}:

{
  imports = [
    self.modules.homeManager.cli
    self.modules.homeManager.editor
    ../service/syncthing.nix
    self.modules.homeManager.shell
  ];

  home = {
    username = osConfig.my.user.name;
    homeDirectory = "/home/${osConfig.my.user.name}";
    stateVersion = "25.05";
    enableNixpkgsReleaseCheck = false;
  };

  # Create symlink of nix-config
  home.file."nix-config" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-config";
  };

  xdg.configFile."fastfetch/config.jsonc".source = ../fastfetch/config.jsonc;

  # Environment variables
  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
    PAGER = "bat";
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
