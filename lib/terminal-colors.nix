# Shared terminal color scheme generator
# Maps Base16 color scheme to standard terminal ANSI colors
# This eliminates duplication across alacritty, kitty, and ghostty configs
{ theme }:

{
  # Generate ANSI color mappings from Base16 color scheme
  ansi = {
    # Normal colors (0-7)
    black = theme.colorScheme.base00;
    red = theme.colorScheme.base08;
    green = theme.colorScheme.base0B;
    yellow = theme.colorScheme.base0A;
    blue = theme.colorScheme.base0D;
    magenta = theme.colorScheme.base0E;
    cyan = theme.colorScheme.base0C;
    white = theme.colorScheme.base05;

    # Bright colors (8-15)
    brightBlack = theme.colorScheme.base03;
    brightRed = theme.colorScheme.base08;
    brightGreen = theme.colorScheme.base0B;
    brightYellow = theme.colorScheme.base0A;
    brightBlue = theme.colorScheme.base0D;
    brightMagenta = theme.colorScheme.base0E;
    brightCyan = theme.colorScheme.base0C;
    brightWhite = theme.colorScheme.base07;
  };

  # Primary colors (background, foreground, cursor, selection)
  primary = {
    background = theme.colorScheme.base00;
    foreground = theme.colorScheme.base05;
    cursor = theme.semantic.variable;
    cursorText = theme.colorScheme.base00;
    selection = theme.colorScheme.base02;
    selectionText = theme.colorScheme.base05;
  };
}
