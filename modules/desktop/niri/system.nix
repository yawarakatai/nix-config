{ lib, pkgs, ... }:

let
  inherit (lib) mkOption types;
in
{
  options.my = {
    display.outputs = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            enable = mkOption {
              type = types.bool;
              default = true;
              description = "Whether this display output is enabled.";
            };

            primary = mkOption {
              type = types.bool;
              default = false;
              description = "Whether this output receives focus when Niri starts.";
            };

            width = mkOption {
              type = types.int;
              default = 1920;
              description = "Display mode width in physical pixels.";
            };

            height = mkOption {
              type = types.int;
              default = 1080;
              description = "Display mode height in physical pixels.";
            };

            refresh = mkOption {
              type = types.float;
              default = 60.0;
              description = "Display refresh rate.";
            };

            customMode = mkOption {
              type = types.bool;
              default = false;
              description = "Whether to configure the display mode as a custom mode.";
            };

            scale = mkOption {
              type = types.float;
              default = 1.0;
              description = "Wayland output scale.";
            };

            vrr = mkOption {
              type = types.bool;
              default = false;
              description = "Whether VRR is enabled for this display.";
            };

            transform = mkOption {
              type = types.int;
              default = 0;
              description = "Display transform rotation.";
            };

            position = {
              x = mkOption {
                type = types.int;
                default = 0;
              };
              y = mkOption {
                type = types.int;
                default = 0;
              };
            };
          };
        }
      );
      default = { };
      description = "Niri display outputs keyed by output name.";
    };

    niri = {
      rounding = mkOption {
        type = types.int;
        default = 0;
      };

      gaps = mkOption {
        type = types.int;
        default = 0;
      };

      border = {
        enable = mkOption {
          type = types.bool;
          default = true;
        };

        width = mkOption {
          type = types.int;
          default = 2;
        };

        color = mkOption {
          type = types.str;
          default = "#DCC78E";
          description = "Color used for active compositor borders.";
        };

        inactiveColor = mkOption {
          type = types.str;
          default = "#1A1812";
          description = "Color used for inactive compositor borders.";
        };

        urgentColor = mkOption {
          type = types.str;
          default = "#D04428";
          description = "Color used for urgent compositor borders.";
        };
      };
    };
  };

  config = {
    programs.niri = {
      enable = true;
      # FileChooser comes from the GTK portal (modules/desktop/wayland.nix), so
      # the GNOME portal needs no Nautilus D-Bus service.
      useNautilus = false;
    };

    programs.xwayland.enable = true;

    # Niri ships no polkit agent and Noctalia's built-in one is off by default.
    systemd.user.services.polkit-agent = {
      description = "PolicyKit authentication agent";
      wantedBy = [ "niri.service" ];
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
