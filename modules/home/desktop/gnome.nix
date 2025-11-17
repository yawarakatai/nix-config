# GNOME desktop environment home-manager configuration
# Declaratively configures GNOME settings using dconf
{ config, pkgs, lib, ... }:

{
  # GNOME-specific packages
  home.packages = with pkgs; [
    dconf-editor # GUI for dconf settings
    gnome-tweaks # Additional GNOME settings
  ];

  # Declarative dconf configuration
  dconf.settings = {
    # Desktop Interface Settings
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Colloid-Grey-Dark";
      icon-theme = "Colloid-Grey";
      cursor-theme = "graphite-dark";
      cursor-size = 24;
      enable-hot-corners = false;
      show-battery-percentage = true;
    };

    # Window Manager Preferences
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      resize-with-right-button = true;
    };

    # Mutter (Window Manager) Settings
    "org/gnome/mutter" = {
      edge-tiling = true;
      dynamic-workspaces = true;
      workspaces-only-on-primary = true;
    };

    # Shell Settings
    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Console.desktop"
        "code.desktop"
      ];
    };

    # Input Sources
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "caps:escape" ];
    };

    # Power Settings
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-type = "suspend";
      power-button-action = "interactive";
    };

    # Privacy Settings
    "org/gnome/desktop/privacy" = {
      remember-recent-files = false;
      remove-old-trash-files = true;
      remove-old-temp-files = true;
      old-files-age = lib.hm.gvariant.mkUint32 30;
    };

    # File Chooser Settings
    "org/gtk/settings/file-chooser" = {
      sort-directories-first = true;
      show-hidden = true;
    };

    # Nautilus (Files) Settings
    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
      search-filter-time-type = "last_modified";
      show-delete-permanently = true;
    };

    "org/gnome/nautilus/list-view" = {
      use-tree-view = true;
      default-zoom-level = "small";
    };
  };
}
