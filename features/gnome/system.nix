{ pkgs, ... }:

{
  services.desktopManager.gnome.enable = true;

  services.gnome.core-apps.enable = false;
  services.gnome.core-os-services.enable = true;

  services.gnome.rygel.enable = false;
  services.gnome.gnome-online-accounts.enable = false;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
  ];
}
