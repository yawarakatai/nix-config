# Ghostty terminal emulator configuration
{ config, pkgs, uiSettings, ... }:

{
  programs.ghostty = {
    enable = true;

    settings = {
      # Theme - will be configured by stylix
      background-opacity = uiSettings.opacity.terminal;

      # Font configuration - will be configured by stylix
      font-feature = [
        "-calt" # Disable ligatures
        "-liga"
      ];

      # Window settings
      window-padding-x = 8;
      window-padding-y = 8;
      window-decoration = true;

      # Cursor
      cursor-style = "block";
      cursor-style-blink = false;

      # Misc
      confirm-close-surface = false;
      copy-on-select = false;
    };
  };
}
