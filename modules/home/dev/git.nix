# Git configuration with lazygit and delta
{ pkgs, ... }:

{
  # Install delta for better diffs
  home.packages = with pkgs; [
    delta
  ];

  # Git configuration
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "yawarakatai";
        email = "186454332+yawarakatai@users.noreply.github.com";
      };

      init.defaultBranch = "main";
      pull.rebase = false;
      core.editor = "hx";

      # Delta for better diffs
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      delta = {
        navigate = true;
        light = false;
        line-numbers = true;
        syntax-theme = "base16";
      };

      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
  };

  # Lazygit configuration
  programs.lazygit = {
    enable = true;

    settings = {
      gui = {
        showFileTree = true;
        showListFooter = true;
        showRandomTip = false;
        showCommandLog = false;
        nerdFontsVersion = "3";
      };

      git = {
        pagers = [
          {
            colorArg = "always";
            pager = "delta --dark --paging=never";
          }
        ];

        commit = {
          signOff = false;
        };

        merging = {
          manualCommit = false;
          args = "";
        };
      };

      # =============================================
      #  Colemak DH keybindings
      #
      #  Movement (neio):
      #    n = left    e = down    i = up    o = right
      #
      #  Displaced:
      #    n (next match) -> k
      #    e (edit)       -> stays on 'e' contextually (lazygit uses explicit edit)
      # =============================================
      keybinding = {
        universal = {
          quit = "q";
          quit-alt1 = "<c-c>";
          return = "<esc>";
          quitWithoutChangingDirectory = "Q";
          togglePanel = "<tab>";

          # Navigation: neio
          prevItem = "<up>";
          nextItem = "<down>";
          prevItem-alt = "i"; # up
          nextItem-alt = "e"; # down
          prevPage = ",";
          nextPage = ".";
          scrollLeft = "N"; # Shift+n = scroll left
          scrollRight = "O"; # Shift+o = scroll right
          gotoTop = "<";
          gotoBottom = ">";
          toggleRangeSelect = "v";
          rangeSelectDown = "<s-down>";
          rangeSelectUp = "<s-up>";
          prevBlock = "<left>";
          nextBlock = "<right>";
          prevBlock-alt = "n"; # left panel
          nextBlock-alt = "o"; # right panel
          nextMatch = "k"; # displaced from n
          prevMatch = "K";
          startSearch = "/";
          optionMenu = "?";
          optionMenu-alt1 = "<c-w>";
          select = "<space>";
          goInto = "<enter>";
          confirm = "<enter>";
          remove = "d";
          new = "a"; # 'n' is taken by movement
          edit = "w"; # edit with editor
          openFile = "f"; # open file
          scrollUpMain = "<pgup>";
          scrollDownMain = "<pgdown>";
          scrollUpMain-alt1 = "I"; # Shift+i = scroll up main
          scrollDownMain-alt1 = "E"; # Shift+e = scroll down main
          scrollUpMain-alt2 = "<c-u>";
          scrollDownMain-alt2 = "<c-d>";
          executeShellCommand = ":";
          createRebaseOptionsMenu = "m";
          pushFiles = "P";
          pullFiles = "p";
          refresh = "R";
          createPatchOptionsMenu = "<c-p>";
          nextTab = "]";
          prevTab = "[";
          nextScreenMode = "+";
          prevScreenMode = "_";
          undo = "z";
          redo = "<c-z>";
          filteringMenu = "<c-s>";
          diffingMenu = "W";
          diffingMenu-alt = "<c-e>";
          copyToClipboard = "<c-o>";
          openRecentRepos = "<c-r>";
          submitEditorText = "<enter>";
          extrasMenu = "@";
          toggleWhitespaceInDiffView = "<c-w>";
          increaseContextInDiffView = "}";
          decreaseContextInDiffView = "{";
        };
      };
    };
  };
}
