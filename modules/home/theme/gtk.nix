# GTK configuration
# Theme and cursor are managed by stylix
{ pkgs, ... }:

{
  gtk = {
    enable = true;

    # Icon theme (not managed by stylix)
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
}
