{ config, pkgs, theme, ... }:

{
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
      "comment" = { fg = theme.semantic.comment; italic = true; };
      "keyword" = { fg = theme.semantic.keyword; bold = true; };
      "keyword.control" = { fg = theme.semantic.keyword; };
      "keyword.directive" = { fg = theme.semantic.keyword; };
      "function" = { fg = theme.semantic.function; };
      "function.method" = { fg = theme.semantic.function; };
      "function.macro" = { fg = theme.semantic.keyword; };
      "string" = theme.semantic.string;
      "number" = theme.semantic.number;
      "constant" = { fg = theme.semantic.constant; bold = true; };
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
      "markup.heading" = { fg = theme.semantic.function; bold = true; };
      "markup.list" = theme.semantic.keyword;
      "markup.bold" = { bold = true; };
      "markup.italic" = { italic = true; };
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

    # Language servers
    languages = {
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
        }
        {
          name = "rust";
          auto-format = true;
        }
        {
          name = "python";
          auto-format = true;
        }
      ];
    };
  };
}
