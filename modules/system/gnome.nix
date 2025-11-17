# Minimal GNOME desktop environment configuration
# Based on NixOS Wiki: https://wiki.nixos.org/wiki/GNOME
{ config, pkgs, ... }:

{
  # Enable GNOME Desktop Environment (25.11+ syntax)
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Disable GNOME's suite of applications for minimal installation
  # This excludes core apps, developer tools, and games
  services.gnome.core-apps.enable = false;
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = false;

  # Install only essential GNOME apps
  environment.systemPackages = with pkgs; [
    gnome-console # GNOME terminal
    nautilus # File manager
    gnome-text-editor # Text editor
    gnome-system-monitor # System monitor
    gnome-disk-utility # Disk utility
    gnome-calculator # Calculator
    gnome-settings-daemon # Required for settings
    gnome-control-center # Settings app
  ];

  # Exclude remaining unnecessary packages
  environment.gnome.excludePackages = with pkgs; [
    epiphany # GNOME Web browser
    geary # Email client
    gnome-tour # Welcome tour
    gnome-user-docs # User documentation
    yelp # Help viewer
  ];
}
