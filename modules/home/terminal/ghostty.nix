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
      quick-terminal-autohide = false;

      keybind = [
        # Tab navigation (Colemak-DH neio, Alt mod)
        "alt+n=previous_tab"
        "alt+o=next_tab"
        "alt+t=new_tab"
        "alt+w=new_window"
        "alt+q=close_surface"

        # Splits
        "alt+s=new_split:right"
        "alt+d=new_split:down"

        # Split navigation (Colemak-DH neio)
        "alt+shift+n=goto_split:left"
        "alt+shift+e=goto_split:down"
        "alt+shift+i=goto_split:up"
        "alt+shift+o=goto_split:right"

        # Split resize
        "ctrl+alt+n=resize_split:left,10"
        "ctrl+alt+e=resize_split:down,10"
        "ctrl+alt+i=resize_split:up,10"
        "ctrl+alt+o=resize_split:right,10"

        # Split layout
        "alt+shift+enter=toggle_split_zoom"
        "alt+equal=equalize_splits"

        # Quick terminal
        "alt+space=toggle_quick_terminal"
      ];
    };
  };
}
