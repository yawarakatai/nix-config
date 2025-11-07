{ config, pkgs, theme, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode; # Use vscode (proprietary) for full extension support
    profiles.default = {
      userSettings = {
        # Editor settings
        "editor.fontFamily" = "'${theme.font.name}', '${theme.font.nameCJK}'";
        "editor.fontSize" = theme.font.size;
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

        # Workbench
        "workbench.colorTheme" = "Default Dark Modern"; # Will be customized
        "workbench.iconTheme" = "material-icon-theme";
        "workbench.startupEditor" = "none";

        # Terminal
        "terminal.integrated.fontFamily" = "'${theme.font.name}'";
        "terminal.integrated.fontSize" = theme.font.size;
        "terminal.integrated.cursorBlinking" = true;
        "terminal.integrated.defaultProfile.linux" = "nushell";

        # Files
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 1000;
        "files.trimTrailingWhitespace" = true;
        "files.insertFinalNewline" = true;

        # Nix
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";

        # Git
        "git.autofetch" = true;
        "git.confirmSync" = false;

        # Other
        "telemetry.telemetryLevel" = "off";
        "update.mode" = "none"; # Updates managed by Nix
      };

      extensions = with pkgs.vscode-extensions; [
        # Nix
        jnoortheen.nix-ide

        # Rust
        rust-lang.rust-analyzer

        # Python
        ms-python.python
        ms-python.vscode-pylance

        # C/C++
        ms-vscode.cpptools

        # Git
        eamodio.gitlens

        # UI
        pkief.material-icon-theme

        # Other useful extensions
        # esbenp.prettier-vscode
        # dbaeumer.vscode-eslint
      ];
    };


  };
}
