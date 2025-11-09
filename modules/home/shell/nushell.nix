{
  config,
  pkgs,
  theme,
  ...
}:

{
  programs.nushell = {
    enable = true;

    # Add skim plugin for fuzzy finding
    plugins = [
      pkgs.nushellPlugins.skim
    ];

    configFile.text = ''
      # Nushell configuration
      $env.config = {
        show_banner: false

        color_config: {
          separator: "${theme.colorScheme.base03}"
          leading_trailing_space_bg: "${theme.colorScheme.base00}"
          header: { fg: "${theme.semantic.function}" attr: "b" }
          empty: "${theme.colorScheme.base05}"
          bool: "${theme.semantic.constant}"
          int: "${theme.semantic.number}"
          filesize: "${theme.semantic.info}"
          duration: "${theme.semantic.warning}"
          date: "${theme.semantic.keyword}"
          range: "${theme.semantic.variable}"
          float: "${theme.semantic.number}"
          string: "${theme.semantic.string}"
          nothing: "${theme.semantic.comment}"
          binary: "${theme.semantic.keyword}"
          cell-path: "${theme.colorScheme.base05}"
          row_index: { fg: "${theme.semantic.info}" attr: "b" }
          record: "${theme.colorScheme.base05}"
          list: "${theme.colorScheme.base05}"
          block: "${theme.colorScheme.base05}"
          hints: "${theme.semantic.comment}"
        }

        completions: {
          case_sensitive: false
          quick: true
          partial: true
          algorithm: "fuzzy"
        }

        keybindings: [
          {
            name: fuzzy_history
            modifier: control
            keycode: char_r
            mode: [emacs vi_normal vi_insert]
            event: {
              send: ExecuteHostCommand
              cmd: "commandline edit --insert (history | each { |it| $it.command } | uniq | reverse | str join (char nl) | fzf --layout=reverse --height=40% | decode utf-8 | str trim)"
            }
          }
          {
            name: skim_file_picker
            modifier: control
            keycode: char_t
            mode: [emacs vi_normal vi_insert]
            event: {
              send: ExecuteHostCommand
              cmd: "commandline edit --insert (fd --type f | sk)"
            }
          }
          {
            name: skim_directory_picker
            modifier: alt
            keycode: char_c
            mode: [emacs vi_normal vi_insert]
            event: {
              send: ExecuteHostCommand
              cmd: "cd (fd --type d | sk)"
            }
          }
        ]
      }
    '';

    environmentVariables = {
      EDITOR = "hx";
      VISUAL = "hx";
      PAGER = "bat";
    };

    shellAliases = {
      cc = "cd ~/.config/nix-config";

      # Better defaults
      ll = "ls -la";
      la = "ls -a";
      cat = "bat";
      find = "fd";
      grep = "rg";
      du = "dust";
      df = "duf";
      ps = "procs";
      top = "btm";

      # Git aliases
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gcm = "git commit -am";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";
      gm = "git merge";
      gb = "git branch";
      gco = "git checkout";
    };
  };
}
