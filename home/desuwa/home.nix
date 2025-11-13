{ config, pkgs, vars, inputs, ... }:

{
  # Import common home configuration
  imports = [
    ../common.nix
  ];

  # User-specific settings
  home.username = vars.username;
  home.homeDirectory = "/home/${vars.username}";

  # Host-specific packages for desuwa
  home.packages = with pkgs; [
    steam
  ];
}
