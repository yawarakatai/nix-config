{ config, pkgs, theme, ... }:

let
  # Import shared terminal color scheme
  termColors = import ../../../lib/terminal-colors.nix { inherit theme; };
in
{
  programs.kitty = {
    enable = false;

    settings = {
      # Font configuration
      font_family = theme.font.name;
      font_size = theme.font.size;
      disable_ligatures = "cursor"; # Disable ligatures at cursor position

      # Window configuration
      window_padding_width = 8;
      hide_window_decorations = "yes";
      background_opacity = theme.opacity.terminal;
      background_blur = 1;

      # Cursor
      cursor = termColors.primary.cursor;
      cursor_shape = "block";
      cursor_blink_interval = 1;
      cursor_stop_blinking_after = 0; # Never stop blinking

      # Selection
      selection_background = termColors.primary.selection;
      selection_foreground = termColors.primary.selectionText;

      # Mouse
      mouse_hide_wait = 3.0;
      copy_on_select = "yes";

      # Clipboard
      clipboard_control = "write-clipboard write-primary read-clipboard read-primary";

      # Theme - Base colors
      background = termColors.primary.background;
      foreground = termColors.primary.foreground;

      # Terminal colors (0-15) - Using shared color scheme
      # Normal colors
      color0 = termColors.ansi.black;
      color1 = termColors.ansi.red;
      color2 = termColors.ansi.green;
      color3 = termColors.ansi.yellow;
      color4 = termColors.ansi.blue;
      color5 = termColors.ansi.magenta;
      color6 = termColors.ansi.cyan;
      color7 = termColors.ansi.white;

      # Bright colors
      color8 = termColors.ansi.brightBlack;
      color9 = termColors.ansi.brightRed;
      color10 = termColors.ansi.brightGreen;
      color11 = termColors.ansi.brightYellow;
      color12 = termColors.ansi.brightBlue;
      color13 = termColors.ansi.brightMagenta;
      color14 = termColors.ansi.brightCyan;
      color15 = termColors.ansi.brightWhite;

      # Performance
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = "yes";

      # Bell
      enable_audio_bell = "no";
      visual_bell_duration = 0.0;
      window_alert_on_bell = "no";
    };

    # Key bindings
    keybindings = {
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
    };
  };
}
