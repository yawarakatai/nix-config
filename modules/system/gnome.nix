# Minimal GNOME desktop environment configuration
{ config, pkgs, ... }:

{
  # Enable X11 (required for GNOME)
  services.xserver.enable = true;

  # Enable GNOME Desktop Environment
  services.xserver.desktopManager.gnome.enable = true;

  # Enable GDM (GNOME Display Manager)
  services.xserver.displayManager.gdm.enable = true;

  # Exclude unnecessary GNOME applications to keep installation minimal
  environment.gnome.excludePackages = with pkgs; [
    # GNOME Apps
    epiphany # GNOME Web browser
    geary # Email client
    gnome-tour # Welcome tour
    gnome-music # Music player
    gnome-photos # Photo viewer/manager
    gnome-contacts # Contacts manager
    gnome-maps # Maps application
    gnome-weather # Weather app
    gnome-calendar # Calendar
    gnome-characters # Character map
    gnome-clocks # Clocks
    gnome-logs # System logs viewer
    gnome-connections # Remote desktop client
    simple-scan # Document scanner
    totem # Video player
    yelp # Help viewer

    # Games
    gnome-chess
    gnome-mahjongg
    gnome-mines
    gnome-sudoku
    gnome-tetravex
    hitori
    iagno
    tali
    quadrapassel
    atomix
  ];
}
