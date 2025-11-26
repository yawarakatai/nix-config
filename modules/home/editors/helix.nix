{ config, pkgs, theme, ... }:

{
  # Install language servers and tools needed by Helix
  home.packages = with pkgs; [
    # === LSP Servers ===
    nil # Nix LSP
    rust-analyzer # Rust LSP
    pyright # Python LSP (fast, recommended)
    # python312Packages.python-lsp-server  # Alternative Python LSP
    clang-tools # C/C++ LSP (includes clangd)
    haskell-language-server # Haskell LSP
    nodePackages.typescript-language-server # TypeScript/JavaScript LSP
    taplo # TOML LSP and formatter
    yaml-language-server # YAML LSP
    marksman # Markdown LSP

    # === Formatters ===
    nixpkgs-fmt # Nix formatter
    rustfmt # Rust formatter
    black # Python formatter
    nodePackages.prettier # Web formatter (JS, TS, HTML, CSS, JSON, etc.)

    # === Debug Adapters (optional) ===
    lldb # C/C++/Rust debugger
  ];

  programs.helix = {
    enable = true;

    settings = {
      theme = "neon-night";

      editor = {
        line-number = "relative";
        mouse = true;
        cursorline = true;
        color-modes = true;
        auto-save = true;
        completion-trigger-len = 1;
        true-color = true;

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
          left = [ "mode" "spinner" "file-name" "file-modification-indicator" ];
          center = [ "diagnostics" ];
          right = [ "selections" "position" "file-encoding" "file-line-ending" "file-type" ];
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
      };

      keys.normal = {
        space.space = "file_picker";
        space.w = ":w";
        space.q = ":q";
        space.x = ":x";
        esc = [ "collapse_selection" "keep_primary_selection" ];
      };

      keys.insert = {
        j.k = "normal_mode";
      };
    };

    # Custom theme definition
    themes.neon-night = {
      # UI colors
      "ui.background" = { bg = theme.colorScheme.base00; };
      "ui.text" = theme.colorScheme.base05;
      "ui.text.focus" = theme.colorScheme.base07;
      "ui.text.inactive" = theme.colorScheme.base04;
      "ui.selection" = { bg = theme.colorScheme.base02; };
      "ui.selection.primary" = { bg = theme.colorScheme.base02; };
      "ui.cursor" = { fg = theme.colorScheme.base00; bg = theme.semantic.variable; };
      "ui.cursor.primary" = { fg = theme.colorScheme.base00; bg = theme.semantic.variable; };
      "ui.cursor.match" = { bg = theme.colorScheme.base02; underline = { style = "line"; }; };
      "ui.linenr" = theme.colorScheme.base03;
      "ui.linenr.selected" = theme.semantic.variable;
      "ui.statusline" = { fg = theme.colorScheme.base05; bg = theme.colorScheme.base01; };
      "ui.statusline.inactive" = { fg = theme.colorScheme.base04; bg = theme.colorScheme.base01; };
      "ui.statusline.normal" = { fg = theme.colorScheme.base00; bg = theme.semantic.info; };
      "ui.statusline.insert" = { fg = theme.colorScheme.base00; bg = theme.semantic.success; };
      "ui.statusline.select" = { fg = theme.colorScheme.base00; bg = theme.semantic.warning; };
      "ui.popup" = { fg = theme.colorScheme.base05; bg = theme.colorScheme.base01; };
      "ui.window" = theme.colorScheme.base01;
      "ui.help" = { fg = theme.colorScheme.base05; bg = theme.colorScheme.base01; };
      "ui.menu" = { fg = theme.colorScheme.base05; bg = theme.colorScheme.base01; };
      "ui.menu.selected" = { fg = theme.colorScheme.base00; bg = theme.semantic.variable; };
      "ui.virtual.whitespace" = theme.colorScheme.base03;
      "ui.virtual.ruler" = { bg = theme.colorScheme.base01; };
      "ui.virtual.indent-guide" = theme.colorScheme.base03;

      # Syntax highlighting
      "comment" = { fg = theme.semantic.comment; modifiers = [ "italic" ]; };
      "keyword" = { fg = theme.semantic.keyword; modifiers = [ "bold" ]; };
      "keyword.control" = { fg = theme.semantic.keyword; };
      "keyword.directive" = { fg = theme.semantic.keyword; };
      "function" = { fg = theme.semantic.function; };
      "function.method" = { fg = theme.semantic.function; };
      "function.macro" = { fg = theme.semantic.keyword; };
      "string" = theme.semantic.string;
      "number" = theme.semantic.number;
      "constant" = { fg = theme.semantic.constant; modifiers = [ "bold" ]; };
      "constant.builtin" = { fg = theme.semantic.constant; };
      "variable" = theme.semantic.variable;
      "variable.parameter" = theme.semantic.variable;
      "variable.builtin" = { fg = theme.semantic.keyword; };
      "operator" = theme.semantic.operator;
      "type" = theme.semantic.function;
      "type.builtin" = { fg = theme.semantic.function; };
      "property" = theme.semantic.variable;
      "label" = theme.semantic.keyword;
      "punctuation" = theme.colorScheme.base05;
      "punctuation.delimiter" = theme.colorScheme.base05;
      "punctuation.bracket" = theme.colorScheme.base05;

      # Markup
      "markup.heading" = { fg = theme.semantic.function; modifiers = [ "bold" ]; };
      "markup.list" = theme.semantic.keyword;
      "markup.bold" = { modifiers = [ "bold" ]; };
      "markup.italic" = { modifiers = [ "italic" ]; };
      "markup.link.url" = { fg = theme.semantic.info; underline = { style = "line"; }; };
      "markup.link.text" = theme.semantic.string;
      "markup.quote" = theme.semantic.comment;
      "markup.raw" = theme.semantic.string;

      # Diagnostics
      "error" = theme.semantic.error;
      "warning" = theme.semantic.warning;
      "info" = theme.semantic.info;
      "hint" = theme.semantic.comment;

      # Diff
      "diff.plus" = theme.semantic.gitAdded;
      "diff.minus" = theme.semantic.gitDeleted;
      "diff.delta" = theme.semantic.gitModified;
    };

    # Language-specific configurations
    languages = {
      language = [
        # Nix
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
          };
          language-servers = [ "nil" ];
        }

        # Rust
        {
          name = "rust";
          auto-format = true;
          formatter = {
            command = "${pkgs.rustfmt}/bin/rustfmt";
            args = [ "--edition" "2021" ];
          };
          language-servers = [ "rust-analyzer" ];
        }

        # Python
        {
          name = "python";
          auto-format = true;
          formatter = {
            command = "${pkgs.black}/bin/black";
            args = [ "--quiet" "-" ];
          };
          language-servers = [ "pyright" ];
        }

        # C/C++
        {
          name = "c";
          auto-format = true;
          language-servers = [ "clangd" ];
        }
        {
          name = "cpp";
          auto-format = true;
          language-servers = [ "clangd" ];
        }

        # Haskell
        {
          name = "haskell";
          auto-format = true;
          language-servers = [ "haskell-language-server" ];
        }

        # JavaScript/TypeScript
        {
          name = "javascript";
          auto-format = true;
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = [ "--parser" "typescript" ];
          };
          language-servers = [ "typescript-language-server" ];
        }
        {
          name = "typescript";
          auto-format = true;
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = [ "--parser" "typescript" ];
          };
          language-servers = [ "typescript-language-server" ];
        }

        # TOML
        {
          name = "toml";
          auto-format = true;
          language-servers = [ "taplo" ];
        }

        # YAML
        {
          name = "yaml";
          auto-format = true;
          language-servers = [ "yaml-language-server" ];
        }

        # Markdown
        {
          name = "markdown";
          auto-format = true;
          language-servers = [ "marksman" ];
        }
      ];

      # Language server configurations
      language-server = {
        nil = {
          command = "${pkgs.nil}/bin/nil";
        };

        rust-analyzer = {
          command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
          config = {
            check = {
              command = "clippy";
            };
          };
        };

        pyright = {
          command = "${pkgs.pyright}/bin/pyright-langserver";
          args = [ "--stdio" ];
        };

        clangd = {
          command = "${pkgs.clang-tools}/bin/clangd";
          args = [ "--background-index" "--clang-tidy" ];
        };

        haskell-language-server = {
          command = "haskell-language-server-wrapper";
          args = [ "--lsp" ];
        };

        typescript-language-server = {
          command = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
          args = [ "--stdio" ];
        };

        taplo = {
          command = "${pkgs.taplo}/bin/taplo";
          args = [ "lsp" "stdio" ];
        };

        yaml-language-server = {
          command = "${pkgs.yaml-language-server}/bin/yaml-language-server";
          args = [ "--stdio" ];
        };

        marksman = {
          command = "${pkgs.marksman}/bin/marksman";
          args = [ "server" ];
        };
      };
    };
  };
}

