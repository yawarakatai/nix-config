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

      # =============================================
      #  Colemak DH keybindings
      #
      #  Movement (neio):
      #    n = left    e = down    i = up    o = right
      #
      #  Displaced keys relocated:
      #    n (next match)   -> k
      #    e (word end)     -> j
      #    i (insert)       -> l
      #    o (open below)   -> h
      #    N (prev match)   -> K
      #    E (word end back) -> J  (move_prev_word_end)
      #    I (insert at bol) -> L
      #    O (open above)   -> H
      # =============================================
      keys = {
        normal = {
          # --- Movement (neio) ---
          "n" = "move_char_left";
          "e" = "move_visual_line_down";
          "i" = "move_visual_line_up";
          "o" = "move_char_right";

          "N" = "move_prev_word_start"; # extend/jump left word
          "E" = "half_page_down";
          "I" = "half_page_up";
          "O" = "move_next_word_end";

          # --- Displaced keys ---
          "k" = "search_next";
          "K" = "search_prev";
          "j" = "move_next_word_end";
          "J" = "move_prev_word_end";
          "l" = "insert_mode";
          "L" = "insert_at_line_start";
          "h" = [
            "open_below"
            "normal_mode"
          ];
          "H" = [
            "open_above"
            "normal_mode"
          ];

          # --- Common operations ---
          "D" = [
            "extend_to_line_end"
            "delete_selection"
          ];

          "G" = "goto_file_end";
          "g" = {
            "k" = ":bn"; # g+next -> next buffer
            "K" = ":bp"; # g+prev -> prev buffer
          };

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

          "ret" = "goto_word";

          ";" = [
            "goto_line_end"
            ":append-output echo ';'"
            "collapse_selection"
            "keep_primary_selection"
          ];
        };

        select = {
          # --- Movement in select mode ---
          "n" = "move_char_left";
          "e" = "move_visual_line_down";
          "i" = "move_visual_line_up";
          "o" = "move_char_right";

          "N" = "move_prev_word_start";
          "E" = "half_page_down";
          "I" = "half_page_up";
          "O" = "move_next_word_end";

          "k" = "search_next";
          "K" = "search_prev";
          "j" = "move_next_word_end";
          "J" = "move_prev_word_end";
        };

        insert = {
          "j"."j" = "normal_mode";
        };
      };
    };

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
