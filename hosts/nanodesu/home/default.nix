{
  osConfig,
  pkgs,
  ...
}:
{
  # Import common home configuration
  imports = [
    ../../../modules/home/profiles/desktop.nix
    ../../../modules/home/cli/juice.nix
  ];

  # User-specific settings
  home.username = osConfig.my.user.name;
  home.homeDirectory = "/home/${osConfig.my.user.name}";

  # Host-specific packages for nanodesu
  home.packages = with pkgs; [
    thunderbird
    slack
    zoom-us

    libreoffice-qt

  ];

  # State version - DO NOT CHANGE after initial install
  home.stateVersion = "25.05";
}
