# Ghostty terminal emulator configuration
{ config, pkgs, theme, ... }:

{
  programs.ghostty = {
    enable = true;

    settings = {
      # Theme
      theme = "dark";
      background-opacity = 0.95;

      # Font configuration
      font-family = "JetBrainsMono Nerd Font";
      font-size = 12;
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

      # Shell integration
      shell-integration = true;
      shell-integration-features = "cursor,sudo,title";

      # Misc
      confirm-close-surface = false;
      copy-on-select = false;

      # Colors (matching dark theme)
      foreground = "d8dee9";
      background = "2e3440";

      # Normal colors
      palette = [
        "0=#3b4252"
        "1=#bf616a"
        "2=#a3be8c"
        "3=#ebcb8b"
        "4=#81a1c1"
        "5=#b48ead"
        "6=#88c0d0"
        "7=#e5e9f0"
        "8=#4c566a"
        "9=#bf616a"
        "10=#a3be8c"
        "11=#ebcb8b"
        "12=#81a1c1"
        "13=#b48ead"
        "14=#8fbcbb"
        "15=#eceff4"
      ];
    };
  };
}
