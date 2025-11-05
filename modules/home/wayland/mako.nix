{ config, pkgs, theme, ... }:

{
  services.mako = {
    enable = true;
    
    # Font
    font = "${theme.font.family} ${toString theme.font.size}";
    
    # Colors
    backgroundColor = theme.colorScheme.base00;
    textColor = theme.colorScheme.base05;
    borderColor = theme.border.activeColor;
    progressColor = "over ${theme.semantic.variable}";
    
    # Layout
    width = 400;
    height = 150;
    margin = "16";
    padding = "16";
    borderSize = theme.border.width;
    borderRadius = theme.rounding;
    
    # Behavior
    defaultTimeout = 5000;
    ignoreTimeout = false;
    
    # Grouping
    groupBy = "app-name";
    maxVisible = 5;
    sort = "-time";
    
    # Icons
    icons = true;
    maxIconSize = 48;
    iconPath = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";
    
    # Actions
    actions = true;
    
    # Extra configuration for urgency levels
    extraConfig = ''
      [urgency=low]
      border-color=${theme.semantic.info}
      default-timeout=3000
      
      [urgency=normal]
      border-color=${theme.semantic.warning}
      default-timeout=5000
      
      [urgency=critical]
      border-color=${theme.semantic.error}
      default-timeout=0
      ignore-timeout=1
    '';
  };
}
