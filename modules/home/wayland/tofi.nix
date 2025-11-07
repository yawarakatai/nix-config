{ config, pkgs, theme, ... }:

{
  programs.tofi = {
    enable = true;

    settings = {
      # Font
      font = theme.font.family;
      font-size = theme.font.size * 2;

      # Window
      height = "100%";
      width = "100%";
      border-width = theme.border.width;
      border-color = theme.border.activeColor;
      outline-width = 0;
      padding-left = "2%";
      padding-top = "2%";
      corner-radius = theme.rounding;

      # Colors
      background-color = theme.colorScheme.base00;
      text-color = theme.colorScheme.base05;
      prompt-color = theme.semantic.keyword;
      placeholder-color = theme.colorScheme.base04;
      input-color = theme.colorScheme.base05;
      selection-color = theme.semantic.variable;
      selection-background = theme.colorScheme.base02;
      selection-background-padding = 8;

      # Input
      prompt-text = "run: ";
      placeholder-text = "Search...";

      # Behavior
      fuzzy-match = true;
      num-results = 10;
      result-spacing = 16;

      # Performance
      late-keyboard-init = true;

      # History
      history = true;

      # Misc
      hide-cursor = true;
      drun-launch = true;
    };
  };
}
