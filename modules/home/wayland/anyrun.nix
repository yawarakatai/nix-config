{
  config,
  pkgs,
  theme,
  inputs,
  ...
}:

let
  anyrun = inputs.anyrun.packages.${pkgs.system}.anyrun;
in
{
  programs.anyrun = {
    enable = true;
    package = anyrun;

    config = {
      # Plugin configuration
      plugins = [
        "${anyrun}/lib/libapplications.so"
        "${anyrun}/lib/librink.so"
        "${anyrun}/lib/libshell.so"
        "${anyrun}/lib/libsymbols.so"
      ];

      # Window positioning - centered with reasonable size
      x = {
        fraction = 0.5;
      };
      y = {
        fraction = 0.3;
      };
      width = {
        fraction = 0.4;
      };
      height = {
        fraction = 0.5;
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

    # Custom CSS styling following theme
    extraCss = ''
      * {
        font-family: ${theme.font.family};
        font-size: ${toString theme.font.size}px;
      }

      #window {
        background-color: ${theme.colorScheme.base00};
        border: ${toString theme.border.width}px solid ${theme.border.activeColor};
        border-radius: ${toString theme.rounding}px;
      }

      #entry {
        background-color: ${theme.colorScheme.base00};
        color: ${theme.colorScheme.base05};
        border: none;
        border-radius: ${toString theme.rounding}px;
        padding: 8px;
        margin: 8px;
      }

      #match {
        background-color: transparent;
        color: ${theme.colorScheme.base05};
        padding: 8px;
        margin: 4px 8px;
        border-radius: ${toString theme.rounding}px;
      }

      #match:selected {
        background-color: ${theme.colorScheme.base02};
        color: ${theme.semantic.variable};
        border: ${toString theme.border.width}px solid ${theme.border.activeColor};
      }

      #match:hover {
        background-color: ${theme.colorScheme.base01};
      }

      #plugin {
        background-color: transparent;
        color: ${theme.semantic.keyword};
        padding: 4px 8px;
        margin: 4px 8px;
      }

      list > #match:selected {
        background-color: ${theme.colorScheme.base02};
        color: ${theme.semantic.variable};
      }

      list > #match {
        background-color: transparent;
      }

      #match-title {
        color: ${theme.colorScheme.base05};
        font-weight: bold;
      }

      #match-desc {
        color: ${theme.colorScheme.base04};
        font-size: ${toString (theme.font.size - 2)}px;
      }
    '';

    # Extra configuration for specific plugins
    extraConfigFiles = {
      "applications.ron".text = ''
        Config(
          desktop_actions: false,
          max_entries: 10,
          terminal: Some("ghostty"),
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
