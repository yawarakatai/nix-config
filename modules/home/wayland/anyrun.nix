{ config
, pkgs
, uiSettings
, ...
}:

{
  programs.anyrun = {
    enable = true;

    config = {
      # Plugin configuration
      plugins = [
        "${pkgs.anyrun}/lib/libapplications.so"
        "${pkgs.anyrun}/lib/librink.so"
        "${pkgs.anyrun}/lib/libshell.so"
        "${pkgs.anyrun}/lib/libsymbols.so"
      ];

      # Window positioning - centered and compact
      x = {
        fraction = 0.5;
      };
      y = {
        fraction = 0.3;
      };
      width = {
        fraction = 0.3;
      };

      # Hide icons and plugin info
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = true;
      closeOnClick = true;
      showResultsImmediately = true;
      maxEntries = 10;
    };

    extraCss = ''
      #window {
        border: ${toString uiSettings.border.width}px solid;
        border-radius: ${toString uiSettings.rounding}px;
      }

      #entry {
        border: none;
        border-radius: ${toString uiSettings.rounding}px;
        padding: 8px;
        margin: 8px;
      }

      #match {
        padding: 8px;
        margin: 4px 8px;
        border-radius: ${toString uiSettings.rounding}px;
      }

      #match:selected {
        border: ${toString uiSettings.border.width}px solid;
      }

      #plugin {
        padding: 4px 8px;
        margin: 4px 8px;
      }
    '';

    # Extra configuration for specific plugins
    extraConfigFiles = {
      "applications.ron".text = ''
        Config(
          desktop_actions: false,
          max_entries: 10,
          terminal: Some("alacritty"),
        )
      '';

      "shell.ron".text = ''
        Config(
          prefix: "!",
          shell: Some("nushell"),
        )
      '';

      "symbols.ron".text = ''
        Config(
          prefix: ":",
          symbols: {},
          max_entries: 10,
        )
      '';
    };
  };
}
