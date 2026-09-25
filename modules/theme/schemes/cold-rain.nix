let
  ansi = [
    # Normal
    "16161e"
    "e8788d"
    "6fa5c9"
    "737f9e"
    "6b86b8"
    "a082b8"
    "82c1df"
    "aeb8cf"
    # Bright
    "56617d"
    "f0869a"
    "82b9d9"
    "98a4be"
    "8099c2"
    "b093c5"
    "a8d3e4"
    "d5e4ff"
  ];
  color = index: builtins.elemAt ansi index;
  background = "0c0c0f";
  foreground = color 7;
  selectionBackground = "252b40";
in
{
  base16 = {
    scheme = "Cold Rain";
    author = "yawarakatai";
    base00 = background;
    base01 = color 0;
    base02 = selectionBackground;
    base03 = color 8;
    base04 = color 3;
    base05 = foreground;
    base06 = "c4cee4";
    base07 = color 15;
    base08 = color 1;
    base09 = color 9;
    base0A = color 11;
    base0B = color 2;
    base0C = color 6;
    base0D = color 4;
    base0E = color 5;
    base0F = color 13;
  };

  ghostty = {
    inherit background foreground;
    bold-color = "c4cee4";
    split-divider-color = "303852";
    cursor-color = color 6;
    cursor-text = background;
    selection-background = selectionBackground;
    selection-foreground = color 15;
    palette = builtins.genList (index: "${toString index}=#${color index}") 16;
  };
}
