_:

{
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

        commit.signOff = false;

        merging = {
          manualCommit = false;
          args = "";
        };
      };

      keybinding = {
        universal = {
          quit = "q";
          quit-alt1 = "<c-c>";
          return = "<esc>";
          quitWithoutChangingDirectory = "Q";
          togglePanel = "<tab>";
          prevItem = "<up>";
          nextItem = "<down>";
          prevItem-alt = "i";
          nextItem-alt = "e";
          prevPage = ",";
          nextPage = ".";
          scrollLeft = "N";
          scrollRight = "O";
          gotoTop = "<";
          gotoBottom = ">";
          toggleRangeSelect = "v";
          rangeSelectDown = "<s-down>";
          rangeSelectUp = "<s-up>";
          prevBlock = "<left>";
          nextBlock = "<right>";
          prevBlock-alt = "n";
          nextBlock-alt = "o";
          nextMatch = "k";
          prevMatch = "K";
          startSearch = "/";
          optionMenu = "?";
          optionMenu-alt1 = "<c-w>";
          select = "<space>";
          goInto = "<enter>";
          confirm = "<enter>";
          remove = "d";
          new = "a";
          edit = "w";
          openFile = "<disabled>";
          scrollUpMain = "<pgup>";
          scrollDownMain = "<pgdown>";
          scrollUpMain-alt1 = "I";
          scrollDownMain-alt1 = "E";
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
        branches.createPullRequest = "<c-o>";
        commits.openInBrowser = "<c-b>";
      };
    };
  };
}
