{ vars, ... }:

rec {
  name = "under-construction";

  # Base16 color scheme
  colorScheme = {
    # Base colors - Pure black with subtle grays
    base00 = "#000000"; # Pure black background
    base01 = "#101010"; # Slightly lighter black
    base02 = "#202020"; # Selection background
    base03 = "#404040"; # Comments, invisibles
    base04 = "#808080"; # Dark foreground
    base05 = "#d0d0d0"; # Default foreground
    base06 = "#e8e8e8"; # Light foreground
    base07 = "#ffffff"; # Bright white

    # Accent colors - Coordinated with orange and green
    base08 = "#ff3366"; # Bright red-pink (errors, deletion)
    base09 = "#bd7454"; # Bright orange (warnings, constants)
    base0A = "#ffaa33"; # Warm yellow (classes, search)
    base0B = "#13ac74"; # Lime green (strings, success, additions)
    base0C = "#33ccaa"; # Teal cyan (support, regex)
    base0D = "#4d9fff"; # Sky blue (functions, methods)
    base0E = "#9966ff"; # Soft purple (keywords, tags)
    base0F = "#ff6699"; # Rose pink (deprecated, special)  };
  };

  # Semantic color mappings for easy reference
  semantic = {
    # UI elements
    background = colorScheme.base00;
    foreground = colorScheme.base05;
    selection = colorScheme.base02;
    comment = colorScheme.base03;

    # Syntax highlighting
    keyword = colorScheme.base0E; # Purple
    function = colorScheme.base0D; # Blue
    string = colorScheme.base0B; # Lime green
    number = colorScheme.base09; # Orange
    constant = colorScheme.base0A; # Yellow
    variable = colorScheme.base0C; # Cyan
    operator = colorScheme.base0F; # White

    # Git colors
    gitAdded = colorScheme.base0B; # Lime green
    gitModified = colorScheme.base09; # Orange
    gitDeleted = colorScheme.base08; # Cherry red

    # Status indicators
    success = colorScheme.base0B; # Lime green
    warning = colorScheme.base0A; # Yellow
    error = colorScheme.base08; # Cherry red
    info = colorScheme.base0D; # Cyan
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
