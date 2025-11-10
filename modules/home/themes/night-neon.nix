{ vars, ... }:

{
  name = "Neon Night";

  # Wallpaper path from vars (host-specific absolute path)
  wallpaper = vars.wallpaperPath;

  # Base16 color scheme
  colorScheme = {
    # Base colors - Pure black with subtle grays
    base00 = "#000000"; # Pure black background
    base01 = "#0a0a0a"; # Slightly lighter black
    base02 = "#1a1a1a"; # Selection background
    base03 = "#333333"; # Comments, invisibles
    base04 = "#666666"; # Dark foreground
    base05 = "#cccccc"; # Default foreground
    base06 = "#e0e0e0"; # Light foreground
    base07 = "#ffffff"; # Bright white

    # Accent colors - Vibrant neon colors
    base08 = "#ff0066"; # Cherry red (errors, deletion)
    base09 = "#ff9500"; # Bright orange (warnings, constants)
    base0A = "#ffff00"; # Bright yellow (classes, search)
    base0B = "#00ff00"; # Lime green (strings, success, additions)
    base0C = "#00ffff"; # Cyan (support, regex, escape chars)
    base0D = "#0099ff"; # Bright blue (functions, methods)
    base0E = "#cc00ff"; # Purple (keywords, tags)
    base0F = "#ff00ff"; # Magenta (deprecated, special)
  };

  # Semantic color mappings for easy reference
  semantic = {
    # UI elements
    background = "#000000";
    foreground = "#cccccc";
    selection = "#1a1a1a";
    comment = "#666666";

    # Syntax highlighting
    keyword = "#cc00ff"; # Purple
    function = "#0099ff"; # Blue
    string = "#00ff00"; # Lime green
    number = "#ff9500"; # Orange
    constant = "#ffff00"; # Yellow
    variable = "#00ffff"; # Cyan
    operator = "#cccccc"; # White

    # Git colors
    gitAdded = "#00ff00"; # Lime green
    gitModified = "#ff9500"; # Orange
    gitDeleted = "#ff0066"; # Cherry red

    # Status indicators
    success = "#00ff00"; # Lime green
    warning = "#ffff00"; # Yellow
    error = "#ff0066"; # Cherry red
    info = "#00ffff"; # Cyan
  };

  # Font configuration
  font = {
    # English font
    name = "CommitMono Nerd Font";
    size = 14;

    # Japanese font
    nameCJK = "Noto Sans CJK JP";
    sizeCJK = 14;

    # Combined font family for applications
    family = "CommitMono Nerd Font, Noto Sans CJK JP";
  };

  # Opacity settings (0.0 - 1.0)
  opacity = {
    terminal = 1.0;
    bar = 0.90;
    launcher = 0.95;
    notification = 0.95;
  };

  # Border configuration
  border = {
    enable = false;
    width = 2;
    inactiveColor = "#333333";
    activeColor = "#7f7f7f";
  };

  # Gap configuration
  gaps = {
    inner = 0;
    outer = 0;
  };

  # Corner rounding
  rounding = 0; # Sharp corners for minimal look
}
