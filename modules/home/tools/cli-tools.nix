{ config, pkgs, theme, ... }:

{
  # Collection module for common CLI tools
  # Note: This module groups multiple related utilities together
  # Individual apps get their own modules (e.g., helix.nix, firefox.nix)
  # but small CLI tools are collected here for convenience

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
    skim # fuzzy finder
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
  programs.skim = {
    enable = true;
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
