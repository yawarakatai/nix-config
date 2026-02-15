{ config, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    dotDir = config.xdg.configHome;

    shellAliases = {
      la = "ls -a";
      ll = "ls -la";
    };

    sessionVariables = {
      EDITOR = "hx";
      VISUAL = "hx";
      PAGER = "bat";
    };

    initContent = ''
      # Ctrl+F: Fuzzy file picker
      function tv-files-widget() {
        local selected=$(tv files)
        if [ -n "$selected" ]; then
          LBUFFER+="$selected"
          zle reset-prompt
        fi
      }
      zle -N tv-files-widget

      # Ctrl+T: Fuzzy directory picker and cd
      function tv-dirs-widget() {
        local selected=$(tv dirs)
        if [ -n "$selected" ]; then
          cd "$selected"
          zle reset-prompt
        fi
      }
      zle -N tv-dirs-widget

      # Ctrl+G: Fuzzy string search
      function tv-text-widget() {
        local selected=$(tv text)
        if [ -n "$selected" ]; then
          LBUFFER+="$(echo $selected | cut -d: -f1)"
          zle reset-prompt
        fi
      }
      zle -N tv-text-widget


      # Keybinds
      bindkey '^F' tv-files-widget
      bindkey '^T' tv-dirs-widget
      bindkey '^G' tv-text-widget
    '';
  };
}
