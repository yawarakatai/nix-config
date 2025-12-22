{ pkgs, ... }:

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
      gf = "git fetch";
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
      PAGER = "cat";
    };

    # Main nushell configuration
    extraConfig = ''
      # Register skim plugin
      plugin add ${pkgs.nushellPlugins.skim}/bin/nu_plugin_skim

      # Nushell configuration
      $env.config = {
        show_banner: false

        # Color scheme configuration using theme colors
        color_config: {
          separator: "#333333"
          leading_trailing_space_bg: "#000000"
          header: { fg: "#0099ff" attr: "b" }
          empty: "#cccccc"
          bool: "#ffff00"
          int: "#ff9500"
          filesize: "#00ffff"
          duration: "#ffff00"
          date: "#cc00ff"
          range: "#00ffff"
          float: "#ff9500"
          string: "#00ff00"
          nothing: "#666666"
          binary: "#cc00ff"
          cell-path: "#cccccc"
          row_index: { fg: "#00ffff" attr: "b" }
          record: "#cccccc"
          list: "#cccccc"
          block: "#cccccc"
          hints: "#666666"
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
          # Ctrl+F: Fuzzy file picker
          {
            name: skim_file_picker
            modifier: control
            keycode: char_f
            mode: [emacs vi_normal vi_insert]
            event: {
              send: ExecuteHostCommand
              cmd: "commandline edit --insert (fd --type f | lines | sk | str trim)"
            }
          }

          # Ctrl+T: Fuzzy directory picker and cd
          {
            name: skim_directory_picker
            modifier: control
            keycode: char_t
            mode: [emacs vi_normal vi_insert]
            event: {
              send: ExecuteHostCommand
              cmd: "cd (fd --type d | lines | sk | str trim)"
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
              cmd: "let proc = (ps | select pid name | sk | str trim | split row ' ' | first); if ($proc | is-not-empty) { kill $proc }"
            }
          }
        ]
      }

      # Custom commands
      def ll [...args] { 
        if ($args | is-empty) {
          ls -la .
        } else {
          ls -la ...$args
        }
      }

      def la [...args] { 
        if ($args | is-empty) {
          ls -a .
        } else {
          ls -a ...$args
        }
      }

      def lr [...args] {
        if ($args | is-empty) {
          ls -a **/*
        } else {
          let pattern = $args | str join ","
          glob $"**/*.{($pattern)}" | each { |f| ls -a $f } | flatten
        }
      }

      # Execute program in foreground then close the terminal
      def run [...args: string] {
        let cmd = $args | str join " "
        ^setsid sh -c $'"($cmd)" </dev/null &>/dev/null &'
        exit
      }

      # Execute program in background then close the terminal
      def spawn [...args: string] {
        let cmd = $args | str join " "
        ^setsid sh -c $'"($cmd)" </dev/null &>/dev/null &'
      }
    '';
  };

  # Install nu_plugin_skim
  home.packages = with pkgs; [
    nushellPlugins.skim
  ];
}
