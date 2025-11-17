# Ghostty terminal emulator configuration
# Using under-construction theme colors
{ config, pkgs, theme, ... }:

{
  programs.ghostty = {
    enable = true;

    settings = {
      # Theme - using under-construction color scheme
      background-opacity = theme.opacity.terminal;

      # Font configuration - matching under-construction theme
      font-family = theme.font.name;
      font-size = theme.font.size;
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

      # # Shell integration
      # shell-integration = true;
      # shell-integration-features = "cursor,sudo,title";

      # Misc
      confirm-close-surface = false;
      copy-on-select = false;

      # Colors - under-construction theme (base16)
      foreground = theme.colorScheme.base05; # d0d0d0
      background = theme.colorScheme.base00; # 000000

      # Terminal palette using base16 colors
      palette = [
        # Normal colors (0-7)
        "0=${theme.colorScheme.base00}" # Black
        "1=${theme.colorScheme.base08}" # Red
        "2=${theme.colorScheme.base0B}" # Green
        "3=${theme.colorScheme.base0A}" # Yellow
        "4=${theme.colorScheme.base0D}" # Blue
        "5=${theme.colorScheme.base0E}" # Magenta
        "6=${theme.colorScheme.base0C}" # Cyan
        "7=${theme.colorScheme.base05}" # White
        # Bright colors (8-15)
        "8=${theme.colorScheme.base03}" # Bright Black
        "9=${theme.colorScheme.base08}" # Bright Red
        "10=${theme.colorScheme.base0B}" # Bright Green
        "11=${theme.colorScheme.base0A}" # Bright Yellow
        "12=${theme.colorScheme.base0D}" # Bright Blue
        "13=${theme.colorScheme.base0E}" # Bright Magenta
        "14=${theme.colorScheme.base0C}" # Bright Cyan
        "15=${theme.colorScheme.base07}" # Bright White
      ];
    };
  };
}
