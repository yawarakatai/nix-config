_:

{
  programs.ghostty = {
    enable = true;
    settings = {
      window-padding-x = 20;
      window-padding-y = 20;
      confirm-close-surface = false;
      gtk-titlebar = true;
      shell-integration = "zsh";
      mouse-hide-while-typing = true;
      copy-on-select = "clipboard";
      window-save-state = "always";
      cursor-style = "bar";
      font-feature = [
        "-liga"
        "-calt"
      ];
      quick-terminal-position = "bottom";
      quick-terminal-autohide = false;

      keybind = [
        # Tab navigation
        "alt+n=previous_tab"
        "alt+o=next_tab"
        "alt+t=new_tab"
        "alt+f=start_search"

        # Prompt navigation (Colemak-DH: i = up, e = down)
        "alt+i=jump_to_prompt:-1"
        "alt+e=jump_to_prompt:1"

        # Scrollback
        "alt+y=scroll_page_fractional:-0.5"
        "alt+u=scroll_page_fractional:0.5"

        # Window
        "alt+enter=new_window"
        "alt+q=close_surface"

        # Splits
        "alt+s=new_split:right"
        "alt+d=new_split:down"

        # Split navigation (Colemak-DH neio)
        "alt+shift+n=goto_split:left"
        "alt+shift+e=goto_split:down"
        "alt+shift+i=goto_split:up"
        "alt+shift+o=goto_split:right"
      ];
    };
  };
}
