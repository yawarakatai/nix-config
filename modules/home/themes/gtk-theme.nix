{ pkgs, theme, ... }:

{
  gtk = {
    enable = true;

    theme = {
      name = "Colloid-Grey-Dark";
      package = pkgs.colloid-gtk-theme.override {
        themeVariants = [ "grey" ];
        colorVariants = [ "dark" ];
        sizeVariants = [ "standard" ];
        tweaks = [ "black" "rimless" "normal" ];
      };
    };

    iconTheme = {
      name = "Colloid-Grey";
      package = pkgs.colloid-icon-theme.override {
        colorVariants = [ "grey" ];
      };
    };

    cursorTheme = {
      name = "graphite-dark";
      package = pkgs.graphite-cursors;
      size = 24;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
}
