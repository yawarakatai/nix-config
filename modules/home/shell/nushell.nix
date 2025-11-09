{ config
, pkgs
, theme
, ...
}:

{
  programs.nushell = {
    enable = true;

    # Git aliases (simple string replacements work fine for git commands)
    shellAliases = {
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

    # Environment variables
    environmentVariables = {
      EDITOR = "hx";
      VISUAL = "hx";
      PAGER = "bat";
    };

    # Extra environment setup (runs before config)
    extraEnv = ''
      # Register the skim plugin
      plugin add ${pkgs.nushellPlugins.skim}/bin/nu_plugin_skim
    '';

    # Main configuration
    extraConfig = let
      # Color scheme from theme
      colors = {
        separator = theme.colorScheme.base03;
        leading_trailing_space_bg = theme.colorScheme.base00;
        header = theme.semantic.function;
        empty = theme.colorScheme.base05;
        bool = theme.semantic.constant;
        int = theme.semantic.number;
        filesize = theme.semantic.info;
        duration = theme.semantic.warning;
        date = theme.semantic.keyword;
        range = theme.semantic.variable;
        float = theme.semantic.number;
        string = theme.semantic.string;
        nothing = theme.semantic.comment;
        binary = theme.semantic.keyword;
        cell_path = theme.colorScheme.base05;
        row_index = theme.semantic.info;
        record = theme.colorScheme.base05;
        list = theme.colorScheme.base05;
        block = theme.colorScheme.base05;
        hints = theme.semantic.comment;
      };
    in ''
      # Nushell configuration
      $env.config = {
        show_banner: false

        color_config: {
          separator: "${colors.separator}"
          leading_trailing_space_bg: "${colors.leading_trailing_space_bg}"
          header: { fg: "${colors.header}" attr: "b" }
          empty: "${colors.empty}"
          bool: "${colors.bool}"
          int: "${colors.int}"
          filesize: "${colors.filesize}"
          duration: "${colors.duration}"
          date: "${colors.date}"
          range: "${colors.range}"
          float: "${colors.float}"
          string: "${colors.string}"
          nothing: "${colors.nothing}"
          binary: "${colors.binary}"
          cell-path: "${colors.cell_path}"
          row_index: { fg: "${colors.row_index}" attr: "b" }
          record: "${colors.record}"
          list: "${colors.list}"
          block: "${colors.block}"
          hints: "${colors.hints}"
        }

        completions: {
          case_sensitive: false
          quick: true
          partial: true
          algorithm: "fuzzy"
        }

        keybindings: [
          {
            name: fuzzy_history_sk
            modifier: control
            keycode: char_r
            mode: [emacs vi_normal vi_insert]
            event: {
              send: ExecuteHostCommand
              cmd: "commandline edit --insert (history | get command | str join (char newline) | sk | str trim)"
            }
          }
          {
            name: skim_file_picker
            modifier: control
            keycode: char_t
            mode: [emacs vi_normal vi_insert]
            event: {
              send: ExecuteHostCommand
              cmd: "commandline edit --insert (fd --type f | str join (char newline) | sk | str trim)"
            }
          }
          {
            name: skim_directory_picker
            modifier: alt
            keycode: char_c
            mode: [emacs vi_normal vi_insert]
            event: {
              send: ExecuteHostCommand
              cmd: "cd (fd --type d | str join (char newline) | sk | str trim)"
            }
          }
          {
            name: process_manager
            modifier: control
            keycode: char_p
            mode: [emacs vi_normal vi_insert]
            event: {
              send: ExecuteHostCommand
              cmd: "let proc = (ps | select pid name | to text | sk | str trim | split row ' ' | first); if ($proc | is-not-empty) { kill $proc }"
            }
          }
        ]
      }

      # Custom commands to replace built-in commands with better alternatives
      def cc [] { cd ~/.config/nix-config }
      def ll [...args] { ls -la ...$args }
      def la [...args] { ls -a ...$args }
      def cat [...args] { bat ...$args }
      def find [...args] { fd ...$args }
      def grep [...args] { rg ...$args }
      def du [...args] { dust ...$args }
      def df [...args] { duf ...$args }
      def ps [...args] { procs ...$args }
      def top [...args] { btm ...$args }
    '';
  };

  # Install nu_plugin_skim
  home.packages = with pkgs; [
    nushellPlugins.skim
  ];
}
