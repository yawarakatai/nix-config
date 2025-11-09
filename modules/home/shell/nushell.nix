{ config
, pkgs
, theme
, ...
}:

{
  programs.nushell = {
    enable = true;

    # Shell aliases for simple command replacements
    shellAliases = {
      cc = "cd ~/.config/nix-config";

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

    # Environment variables
    environmentVariables = {
      EDITOR = "hx";
      VISUAL = "hx";
      PAGER = "bat";
    };

    # Extra environment setup (runs before config.nu)
    extraEnv = ''
      # Register the skim plugin for fuzzy finding
      plugin add ${pkgs.nushellPlugins.skim}/bin/nu_plugin_skim
    '';

    # Main nushell configuration
    extraConfig = ''
      # Nushell configuration
      $env.config = {
        show_banner: false

        # Color scheme configuration using theme colors
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

        # Completion configuration
        completions: {
          case_sensitive: false
          quick: true
          partial: true
          algorithm: "fuzzy"
        }

        # Custom keybindings
        keybindings: [
          # Ctrl+R: Fuzzy history search with skim
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
          # Ctrl+T: Fuzzy file picker
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
          # Alt+C: Fuzzy directory picker and cd
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
          # Ctrl+P: Process manager with fuzzy search
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

      # Custom commands using modern alternatives to classic Unix tools
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
