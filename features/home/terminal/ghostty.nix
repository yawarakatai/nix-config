{ osConfig, ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      font-family = [
        "JetBrainsMonoNL Nerd Font"
        "Noto Sans Mono CJK JP"
      ];
      font-size = 14;
      window-padding-x = osConfig.my.theme.terminal.padding;
      window-padding-y = osConfig.my.theme.terminal.padding;
      background-opacity = osConfig.my.theme.opacity.terminal;
      confirm-close-surface = false;
      gtk-titlebar = true;
      shell-integration = "zsh";
      mouse-hide-while-typing = true;
      copy-on-select = "clipboard";
      window-save-state = "always";
      cursor-style = "bar";
      quick-terminal-position = "bottom";
      quick-terminal-autohide = true;

      keybind = [
        # Tab navigation (Colemak-DH neio, Alt mod)
        "alt+n=previous_tab"
        "alt+o=next_tab"
        "alt+t=new_tab"
        "alt+q=close_surface"

        # Quick terminal
        "alt+space=toggle_quick_terminal"
      ];
    };
  };
}
