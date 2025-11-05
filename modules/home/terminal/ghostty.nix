{ config, pkgs, theme, ... }:

{
  programs.ghostty = {
    enable = true;
    
    settings = {
      # Font configuration
      font-family = theme.font.name;
      font-size = theme.font.size;
      font-feature = [ "-calt" ];  # Disable ligatures if needed
      
      # Theme - Base colors
      background = theme.colorScheme.base00;
      foreground = theme.colorScheme.base05;
      
      # Cursor
      cursor-color = theme.semantic.variable;
      cursor-style = "block";
      cursor-style-blink = true;
      
      # Selection
      selection-background = theme.colorScheme.base02;
      selection-foreground = theme.colorScheme.base05;
      
      # Terminal colors (0-15)
      palette = [
        # Normal colors (0-7)
        "0=${theme.colorScheme.base00}"   # Black
        "1=${theme.colorScheme.base08}"   # Red (Cherry)
        "2=${theme.colorScheme.base0B}"   # Green (Lime)
        "3=${theme.colorScheme.base0A}"   # Yellow
        "4=${theme.colorScheme.base0D}"   # Blue
        "5=${theme.colorScheme.base0E}"   # Magenta (Purple)
        "6=${theme.colorScheme.base0C}"   # Cyan
        "7=${theme.colorScheme.base05}"   # White
        
        # Bright colors (8-15)
        "8=${theme.colorScheme.base03}"   # Bright Black
        "9=${theme.colorScheme.base08}"   # Bright Red
        "10=${theme.colorScheme.base0B}"  # Bright Green
        "11=${theme.colorScheme.base0A}"  # Bright Yellow
        "12=${theme.colorScheme.base0D}"  # Bright Blue
        "13=${theme.colorScheme.base0E}"  # Bright Magenta
        "14=${theme.colorScheme.base0C}"  # Bright Cyan
        "15=${theme.colorScheme.base07}"  # Bright White
      ];
      
      # Window
      window-padding-x = 8;
      window-padding-y = 8;
      window-decoration = false;
      
      # Opacity
      background-opacity = theme.opacity.terminal;
      
      # Shell integration
      shell-integration = true;
      shell-integration-features = "cursor,sudo,title";
      
      # Mouse
      mouse-hide-while-typing = true;
      
      # Misc
      clipboard-read = "allow";
      clipboard-write = "allow";
      copy-on-select = true;
      
      # Keybindings (optional)
      # keybind = [
      #   "ctrl+shift+c=copy_to_clipboard"
      #   "ctrl+shift+v=paste_from_clipboard"
      # ];
    };
  };
}
