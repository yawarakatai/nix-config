{ config, pkgs, theme, ... }:

{
  # Install CLI tools
  home.packages = with pkgs; [
    # File operations
    eza # ls alternative
    bat # cat alternative
    fd # find alternative
    ripgrep # grep alternative

    # System monitoring
    bottom # htop/top alternative
    duf # df alternative
    dust # du alternative
    procs # ps alternative

    # Other utilities
    tealdeer # tldr (simplified man pages)
    fzf # fuzzy finder
    jq # JSON processor
    yq # YAML processor

    # Network tools
    bandwhich # network monitor

    # Misc
    neofetch # system info
    tokei # code statistics
    hyperfine # benchmarking tool
  ];

  # eza configuration
  programs.eza = {
    enable = true;
    enableNushellIntegration = true;
    git = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };

  # bat configuration
  programs.bat = {
    enable = true;
    config = {
      theme = "base16";
      style = "numbers,changes,header";
      italic-text = "always";
    };

    # Custom theme based on our colors
    themes = {
      neon-night = {
        src = pkgs.writeText "neon-night.tmTheme" ''
          <?xml version="1.0" encoding="UTF-8"?>
          <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
          <plist version="1.0">
          <dict>
            <key>name</key>
            <string>Neon Night</string>
            <key>settings</key>
            <array>
              <dict>
                <key>settings</key>
                <dict>
                  <key>background</key>
                  <string>${theme.colorScheme.base00}</string>
                  <key>foreground</key>
                  <string>${theme.colorScheme.base05}</string>
                  <key>caret</key>
                  <string>${theme.semantic.variable}</string>
                  <key>lineHighlight</key>
                  <string>${theme.colorScheme.base01}</string>
                  <key>selection</key>
                  <string>${theme.colorScheme.base02}</string>
                </dict>
              </dict>
            </array>
          </dict>
          </plist>
        '';
      };
    };
  };

  # fzf configuration
  programs.fzf = {
    enable = true;
    # enableNushellIntegration = true;

    colors = {
      bg = theme.colorScheme.base00;
      "bg+" = theme.colorScheme.base01;
      fg = theme.colorScheme.base05;
      "fg+" = theme.colorScheme.base07;
      header = theme.semantic.keyword;
      hl = theme.semantic.success;
      "hl+" = theme.semantic.success;
      info = theme.semantic.info;
      marker = theme.semantic.warning;
      pointer = theme.semantic.variable;
      prompt = theme.semantic.function;
      spinner = theme.semantic.warning;
    };

    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--inline-info"
    ];
  };

  # bottom configuration
  programs.bottom = {
    enable = true;

    settings = {
      flags = {
        color = "default";
        mem_as_value = true;
        tree = true;
      };

      colors = {
        high_battery_color = theme.semantic.success;
        medium_battery_color = theme.semantic.warning;
        low_battery_color = theme.semantic.error;
      };
    };
  };
}
