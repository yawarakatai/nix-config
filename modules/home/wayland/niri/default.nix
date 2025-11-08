{ config, pkgs, theme, ... }:

{
  imports = [
    ./binds.nix
    ./settings.nix
    ./startups.nix
    ./window-rules.nix
  ];

  # Niri-specific configuration only
  # General Wayland packages are in ../wayland-packages.nix
}
