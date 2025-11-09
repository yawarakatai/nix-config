{ config, pkgs, theme, ... }:

let
  # Import shared terminal color scheme
  termColors = import ../../../lib/terminal-colors.nix { inherit theme; };
in
{
  programs.ghostty = {
    enable = false;

    settings = {
      # gtk-single-instance = false;

      # Font configuration
      font-family = theme.font.name;
      font-size = theme.font.size;
      font-feature = [ "-calt" ]; # Disable ligatures if needed

      # Theme - Base colors
      background = termColors.primary.background;
      foreground = termColors.primary.foreground;

      # Cursor
      cursor-color = termColors.primary.cursor;
      cursor-style = "block";
      cursor-style-blink = true;

      # Selection
      selection-background = termColors.primary.selection;
      selection-foreground = termColors.primary.selectionText;

      # Terminal colors (0-15) - Using shared color scheme
      palette = [
        # Normal colors (0-7)
        "0=${termColors.ansi.black}"
        "1=${termColors.ansi.red}"
        "2=${termColors.ansi.green}"
        "3=${termColors.ansi.yellow}"
        "4=${termColors.ansi.blue}"
        "5=${termColors.ansi.magenta}"
        "6=${termColors.ansi.cyan}"
        "7=${termColors.ansi.white}"

        # Bright colors (8-15)
        "8=${termColors.ansi.brightBlack}"
        "9=${termColors.ansi.brightRed}"
        "10=${termColors.ansi.brightGreen}"
        "11=${termColors.ansi.brightYellow}"
        "12=${termColors.ansi.brightBlue}"
        "13=${termColors.ansi.brightMagenta}"
        "14=${termColors.ansi.brightCyan}"
        "15=${termColors.ansi.brightWhite}"
      ];

      # Window
      window-padding-x = 8;
      window-padding-y = 8;
      window-decoration = false;

      # Opacity
      background-opacity = theme.opacity.terminal;
      background-blur = true;

      # Mouse
      mouse-hide-while-typing = true;

      # Misc
      clipboard-read = "allow";
      clipboard-write = "allow";
      copy-on-select = true;

      keybind = [
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+v=paste_from_clipboard"
      ];
    };
  };
}
