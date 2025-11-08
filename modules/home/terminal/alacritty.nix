{ config, pkgs, theme, ... }:

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
          shape = "Block";
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

      # Colors - Base16 color scheme
      colors = {
        primary = {
          background = theme.colorScheme.base00;
          foreground = theme.colorScheme.base05;
        };

        cursor = {
          text = theme.colorScheme.base00;
          cursor = theme.semantic.variable;
        };

        selection = {
          text = theme.colorScheme.base05;
          background = theme.colorScheme.base02;
        };

        # Normal colors
        normal = {
          black = theme.colorScheme.base00;
          red = theme.colorScheme.base08;
          green = theme.colorScheme.base0B;
          yellow = theme.colorScheme.base0A;
          blue = theme.colorScheme.base0D;
          magenta = theme.colorScheme.base0E;
          cyan = theme.colorScheme.base0C;
          white = theme.colorScheme.base05;
        };

        # Bright colors
        bright = {
          black = theme.colorScheme.base03;
          red = theme.colorScheme.base08;
          green = theme.colorScheme.base0B;
          yellow = theme.colorScheme.base0A;
          blue = theme.colorScheme.base0D;
          magenta = theme.colorScheme.base0E;
          cyan = theme.colorScheme.base0C;
          white = theme.colorScheme.base07;
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
