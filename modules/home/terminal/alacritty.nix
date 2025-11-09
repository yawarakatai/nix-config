{ config, pkgs, theme, ... }:

let
  # Import shared terminal color scheme
  termColors = import ../../../lib/terminal-colors.nix { inherit theme; };
in
{
  programs.alacritty = {
    enable = true;

    settings = {
      # Font configuration
      font = {
        normal = {
          family = theme.font.name;
          style = "Regular";
        };
        bold = {
          family = theme.font.name;
          style = "Bold";
        };
        italic = {
          family = theme.font.name;
          style = "Italic";
        };
        bold_italic = {
          family = theme.font.name;
          style = "Bold Italic";
        };
        size = theme.font.size;
      };

      # Window configuration
      window = {
        padding = {
          x = 8;
          y = 8;
        };
        decorations = "none";
        opacity = theme.opacity.terminal;
        blur = true;
      };

      # Cursor
      cursor = {
        style = {
          shape = "Beam";
          blinking = "On";
        };
      };

      # Selection
      selection = {
        save_to_clipboard = true;
      };

      # Mouse
      mouse = {
        hide_when_typing = true;
      };

      # Colors - Using shared terminal color scheme
      colors = {
        primary = {
          background = termColors.primary.background;
          foreground = termColors.primary.foreground;
        };

        cursor = {
          text = termColors.primary.cursorText;
          cursor = termColors.primary.cursor;
        };

        selection = {
          text = termColors.primary.selectionText;
          background = termColors.primary.selection;
        };

        # Normal colors
        normal = {
          black = termColors.ansi.black;
          red = termColors.ansi.red;
          green = termColors.ansi.green;
          yellow = termColors.ansi.yellow;
          blue = termColors.ansi.blue;
          magenta = termColors.ansi.magenta;
          cyan = termColors.ansi.cyan;
          white = termColors.ansi.white;
        };

        # Bright colors
        bright = {
          black = termColors.ansi.brightBlack;
          red = termColors.ansi.brightRed;
          green = termColors.ansi.brightGreen;
          yellow = termColors.ansi.brightYellow;
          blue = termColors.ansi.brightBlue;
          magenta = termColors.ansi.brightMagenta;
          cyan = termColors.ansi.brightCyan;
          white = termColors.ansi.brightWhite;
        };
      };

      # Key bindings
      keyboard.bindings = [
        {
          key = "C";
          mods = "Control|Shift";
          action = "Copy";
        }
        {
          key = "V";
          mods = "Control|Shift";
          action = "Paste";
        }
      ];
    };
  };
}
