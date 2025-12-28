{ pkgs, ... }:

let
  ocp-cad-viewer = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "ocp-cad-viewer";
      publisher = "bernhard-42";
      version = "3.0.1";
      sha256 = "sha256-yO0SDdiRpzf1FDXds78wTaW+RBNpDxanX/EoTMS9ASQ=";
    };
  };
in
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode; # Use vscode (proprietary) for full extension support
    profiles.default = {
      userSettings = {
        # Editor settings - fonts will be configured by stylix
        "editor.fontLigatures" = true;
        "editor.cursorBlinking" = "smooth";
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.lineNumbers" = "relative";
        "editor.renderWhitespace" = "boundary";
        "editor.minimap.enabled" = false;
        "editor.bracketPairColorization.enabled" = true;
        "editor.guides.bracketPairs" = true;
        "editor.inlineSuggest.enabled" = true;
        "editor.suggest.preview" = true;
        "editor.formatOnSave" = true;

        # Workbench - colorTheme managed by stylix
        "workbench.iconTheme" = "material-icon-theme";
        "workbench.startupEditor" = "none";
        "workbench.tree.indent" = 16;
        "workbench.activityBar.location" = "default";

        # Terminal - fonts will be configured by stylix
        "terminal.integrated.cursorBlinking" = true;
        "terminal.integrated.defaultProfile.linux" = "nushell";
        "terminal.integrated.profiles.linux" = {
          nushell = {
            path = "${pkgs.nushell}/bin/nu";
          };
        };

        # Files
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 1000;
        "files.trimTrailingWhitespace" = true;
        "files.insertFinalNewline" = true;
        "files.exclude" = {
          "**/.git" = true;
          "**/.DS_Store" = true;
          "**/node_modules" = true;
          "**/__pycache__" = true;
          "**/.pytest_cache" = true;
        };

        # Nix
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "${pkgs.nil}/bin/nil";

        # Git
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;
        "git.openRepositoryInParentFolders" = "always";

        # Wayland support
        "window.titleBarStyle" = "custom";

        # Privacy
        "telemetry.telemetryLevel" = "off";
        "update.mode" = "none"; # Updates managed by Nix
        "extensions.autoUpdate" = false; # Extensions managed by Nix

        # Marp
        "markdown.marp.html" = "all";

        # Claude Code
        "claudeCode.disableLoginPrompt" = true;
        "claudeCode.preferredLocation" = "panel";
        "claudeCode.useTerminal" = true;
      };

      keybindings = [
        {
          key = "ctrl+shift+e";
          command = "workbench.view.explorer";
        }
      ];

      extensions = with pkgs.vscode-extensions; [
        # Nix
        jnoortheen.nix-ide

        # Rust
        rust-lang.rust-analyzer

        # Python
        ms-python.python
        ms-python.vscode-pylance
        charliermarsh.ruff

        # C/C++
        ms-vscode.cpptools

        # Git
        # eamodio.gitlens

        # UI
        github.github-vscode-theme

        # Icon
        pkief.material-icon-theme

        # Markdown
        marp-team.marp-vscode

        # Godot
        geequlim.godot-tools

        # AI
        anthropic.claude-code

        # 3d cad preview
      ] ++ [ ocp-cad-viewer ];
    };
  };
}
