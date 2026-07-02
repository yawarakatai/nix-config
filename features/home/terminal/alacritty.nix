{ osConfig, ... }:

{
  programs.alacritty = {
    enable = true;

    settings = {
      # Window configuration
      window = {
        padding = {
          x = 14;
          y = 14;
        };
        decorations = "none";
        blur = true;
        opacity = osConfig.my.theme.opacity.terminal;
      };

      # Cursor
      cursor = {
        style = {
          shape = "Beam";
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
