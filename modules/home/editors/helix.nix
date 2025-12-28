{ config, pkgs, ... }:

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
      # Theme - will be configured by stylix

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
