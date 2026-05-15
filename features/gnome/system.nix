{ pkgs, ... }:

{
  services.desktopManager.gnome.enable = true;

  services.gnome.core-apps.enable = true;
  services.gnome.core-os-services.enable = true;

  services.gnome.rygel.enable = false;
  services.gnome.gnome-online-accounts.enable = false;

  environment.gnome.excludePackages = with pkgs; [
    baobab
    cheese
    epiphany
    gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-connections
    gnome-contacts
    gnome-maps
    gnome-music
    gnome-software
    gnome-weather
    simple-scan
    snapshot
    totem
    yelp
  ];
}
