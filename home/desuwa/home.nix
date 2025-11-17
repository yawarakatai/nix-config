{ config, pkgs, vars, inputs, ... }:

{
  # Import common home configuration
  imports = [
    ../common.nix
    ../../modules/home/obs.nix
  ];

  # User-specific settings
  home.username = vars.username;
  home.homeDirectory = "/home/${vars.username}";

  home.packages = with pkgs; [
  ];

  programs.brave = {
    enable = true;
    commandLineArgs = [
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
    ];
  };
}
