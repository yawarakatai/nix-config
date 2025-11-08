{ config, pkgs, theme, ... }:

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
      cursor = theme.semantic.variable;
      cursor_shape = "block";
      cursor_blink_interval = 1;
      cursor_stop_blinking_after = 0; # Never stop blinking

      # Selection
      selection_background = theme.colorScheme.base02;
      selection_foreground = theme.colorScheme.base05;

      # Mouse
      mouse_hide_wait = 3.0;
      copy_on_select = "yes";

      # Clipboard
      clipboard_control = "write-clipboard write-primary read-clipboard read-primary";

      # Theme - Base colors
      background = theme.colorScheme.base00;
      foreground = theme.colorScheme.base05;

      # Terminal colors (0-15)
      # Normal colors
      color0 = theme.colorScheme.base00; # Black
      color1 = theme.colorScheme.base08; # Red
      color2 = theme.colorScheme.base0B; # Green
      color3 = theme.colorScheme.base0A; # Yellow
      color4 = theme.colorScheme.base0D; # Blue
      color5 = theme.colorScheme.base0E; # Magenta
      color6 = theme.colorScheme.base0C; # Cyan
      color7 = theme.colorScheme.base05; # White

      # Bright colors
      color8 = theme.colorScheme.base03; # Bright Black
      color9 = theme.colorScheme.base08; # Bright Red
      color10 = theme.colorScheme.base0B; # Bright Green
      color11 = theme.colorScheme.base0A; # Bright Yellow
      color12 = theme.colorScheme.base0D; # Bright Blue
      color13 = theme.colorScheme.base0E; # Bright Magenta
      color14 = theme.colorScheme.base0C; # Bright Cyan
      color15 = theme.colorScheme.base07; # Bright White

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
