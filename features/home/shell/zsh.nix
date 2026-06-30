{ config, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = false;
    syntaxHighlighting.enable = true;

    dotDir = config.xdg.configHome;

    shellAliases = {
      la = "ls -a";
      ll = "ls -la";
      ls = "eza --icons --group-directories-first";
      tree = "erd";
      cat = "bat --paging=never";
      grep = "rg";
    };

    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      share = true;
    };

    initContent = ''
      setopt auto_cd
      setopt auto_pushd
      setopt pushd_ignore_dups
      DIRSTACKSIZE=20

      # Ctrl+F: File picker (sorted exact → fuzzy fallback)
      function tv-files-widget() {
        local selected=$(tv files-sorted --no-sort --exact)
        [ -z "$selected" ] && selected=$(tv files)
        if [ -n "$selected" ]; then
          LBUFFER+="$selected"
          zle reset-prompt
        fi
      }
      zle -N tv-files-widget

      # Ctrl+T: Directory picker (sorted exact)
      function tv-dirs-widget() {
        local selected=$(tv dirs-sorted --no-sort --exact)
        if [ -n "$selected" ]; then
          cd "$selected"
          zle reset-prompt
        fi
      }
      zle -N tv-dirs-widget

      # Ctrl+G: Text search (exact → fuzzy fallback)
      function tv-text-widget() {
        local selected=$(tv text --exact)
        [ -z "$selected" ] && selected=$(tv text)
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

      # Ctrl+P: Fuzzy process search (ps → PID to buffer)
      function tv-procs-widget() {
        local selected=$(ps aux | tv --exact)
        if [ -n "$selected" ]; then
          local pid=$(echo "$selected" | awk '{print $2}')
          LBUFFER+="$pid"
          zle reset-prompt
        fi
      }
      zle -N tv-procs-widget
      bindkey '^P' tv-procs-widget

      # Ctrl+R: Fuzzy history search
      function tv-history-widget() {
        local selected=$(fc -lr 1 \
          | sed 's/^[[:space:]]*[0-9]*[[:space:]]*//' \
          | tv --exact)
        if [ -n "$selected" ]; then
          LBUFFER+="$selected"
          zle reset-prompt
        fi
      }
      zle -N tv-history-widget
      bindkey '^R' tv-history-widget
    '';
  };
}
