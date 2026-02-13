{ pkgs, ... }:

{
  # Install language servers and tools needed by Helix
  home.packages = with pkgs; [
    # === LSP Servers ===
    nil # Nix LSP
    taplo # TOML LSP and formatter
    yaml-language-server # YAML LSP
    marksman # Markdown LSP
  ];

  programs.helix = {
    enable = true;

    settings = {
      editor = {
        mouse = true;
        cursorline = true;
        color-modes = true;
        auto-save = true;
        completion-trigger-len = 1;
        true-color = true;
        auto-completion = true;
        bufferline = "multiple";
        line-number = "absolute";

        # Clipboard configuration for Wayland
        clipboard-provider = "wayland";

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        file-picker = {
          hidden = false;
        };

        statusline = {
          left = [
            "mode"
            "spinner"
            "file-name"
            "file-modification-indicator"
            "read-only-indicator"
          ];

          center = [ ];

          right = [
            "diagnostics"
            "version-control"
            "selections"
            "position"
            "file-type"
          ];

          separator = "|";

          mode = {
            normal = "NOR";
            insert = "INS";
            select = "SEL";
          };
        };

        whitespace = {
          render = "none";
          characters = {
            space = "·";
            nbsp = "⍽";
            nnbsp = "␣";
            tab = "→";
            tabpad = "·";
            newline = "⏎";
          };
        };

        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };

        indent-guides = {
          render = true;
          character = "│";
        };

        soft-wrap = {
          enable = true;
        };

        inline-diagnostics = {
          cursor-line = "hint";
        };
      };

      keys = {
        normal = {
          D = [
            "extend_to_line_end"
            "delete_selection"
          ];

          # C = [
          #   "extend_to_line_end"
          #   "change_selection"
          # ];

          "G" = "goto_file_end";
          "g" = {
            n = ":bn";
            p = ":bp";
          };

          "H" = ":bp";
          "L" = ":bn";

          space = {
            space = "file_picker";
            w = ":w";
            q = ":q";
            x = ":x";
            B = ":bc";
          };

          esc = [
            "collapse_selection"
            "keep_primary_selection"
          ];

          "tab" = "indent";
          "S-tab" = "unindent";

          "ret" = [
            "open_below"
            "normal_mode"
          ];
          "S-ret" = [
            "open_above"
            "normal_mode"
          ];

          ";" = [
            "goto_line_end"
            ":append-output echo ';'"
            "collapse_selection"
            "keep_primary_selection"
          ];
        };

        insert = {
          j.j = "normal_mode";
          # x.x = ":x";
        };
      };
    };

    # Theme override
    # themes = {
    #   stylix_override = {
    #     "inherits" = "stylix";

    #     # Error base08
    #     "diagnostic.error" = {
    #       underline = {
    #         color = "base08";
    #         style = "curl";
    #       };
    #     };

    #     # Warning base09
    #     "diagnostic.warning" = {
    #       underline = {
    #         color = "base09";
    #         style = "curl";
    #       };
    #     };

    #     # Info  base0D
    #     "diagnostic.info" = {
    #       underline = {
    #         color = "base0D";
    #         style = "curl";
    #       };
    #     };

    #     # Hint base03
    #     "diagnostic.hint" = {
    #       underline = {
    #         color = "base03";
    #         style = "curl";
    #       };
    #     };
    #   };
    # };

    # Language-specific configurations
    languages = {
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "nixfmt";
          };
        }
      ];

      # Language server configurations
      language-server = {
        clangd = {
          args = [
            "--background-index"
            "--clang-tidy"
          ];
        };

        pyright = {
          args = [ "--stdio" ];
          config = {
            python = {
              analysis = {
                autoSearchPaths = true;
                diagnosticMode = "workspace";
                useLibraryCodeForTypes = true;
              };
            };
          };
        };
      };
    };
  };
}
