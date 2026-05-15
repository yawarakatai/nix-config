{ ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "Iosevka Term Nerd Font";
      font-size = 11;
      window-padding-x = 2;
      window-padding-y = 2;
      background-opacity = 0.95;
      confirm-close-surface = false;
      gtk-titlebar = "system";
      shell-integration = "zsh";
    };
  };
}
