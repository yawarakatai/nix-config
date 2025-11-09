{ config, pkgs, vars, ... }:

{
  # Logiops for Logitech device configuration (MX Master 3s)
  environment.systemPackages = with pkgs; [
    logiops
  ];

  # Logiops configuration file
  # To find your device name, run: sudo logid --verbose
  environment.etc."logid.cfg".text = ''
    devices: (
    {
      name: "MX Master 3S";

      # Enable smartshift for the scroll wheel
      smartshift: {
        on: false;
        # threshold: 15;
      };

      # Enable high-resolution scrolling
      hiresscroll: {
        hires: false;
        invert: false;
        target: false;
      };

      thumbwheel: {
        invert: true;
      };

      # DPI settings
      dpi: 8000;

      # Button configuration
      buttons: (

        # 0x52 - Middle button - Browser controls
        {
          cid: 0x52;
          action: {
            type: "Gestures";
            gestures: (
              {
                direction: "None";
                mode: "OnRelease";
                action: {
                  type: "Keypress";
                  keys: ["BTN_MIDDLE"];
                };
              },
              {
                direction: "Up";
                mode: "OnRelease";
                action: {
                  type: "Keypress";
                  keys: ["KEY_LEFTCTRL", "KEY_T"];
                };
              },
              {
                direction: "Down";
                mode: "OnRelease";
                action: {
                  type: "Keypress";
                  keys: ["KEY_LEFTCTRL", "KEY_W"];
                };
              },
              {
                direction: "Left";
                mode: "OnRelease";
                action: {
                  type: "Keypress";
                  keys: ["KEY_LEFTALT", "KEY_LEFT"];
                };
              },
              {
                direction: "Right";
                mode: "OnRelease";
                action: {
                  type: "Keypress";
                  keys: ["KEY_LEFTALT", "KEY_RIGHT"];
                };
              }
            );
          };
        },

        # 0x56 - Forward button - Work shortcuts
        {
          cid: 0x56;
          action: {
            type: "Gestures";
            gestures: (
              {
                direction: "None";
                mode: "OnRelease";
                action: {
                  type: "Keypress";
                  keys: ["KEY_LEFTCTRL", "KEY_S"];
                };
              },
              {
                direction: "Up";
                mode: "OnRelease";
                action: {
                  type: "Keypress";
                  keys: ["KEY_LEFTCTRL", "KEY_C"];
                };
              },
              {
                direction: "Down";
                mode: "OnRelease";
                action: {
                  type: "Keypress";
                  keys: ["KEY_LEFTCTRL", "KEY_V"];
                };
              },
              {
                direction: "Left";
                mode: "OnRelease";
                action: {
                  type: "Keypress";
                  keys: ["KEY_LEFTCTRL", "KEY_Z"];
                };
              },
              {
                direction: "Right";
                mode: "OnRelease";
                action: {
                  type: "Keypress";
                  keys: ["KEY_LEFTCTRL", "KEY_LEFTSHIFT", "KEY_Z"];
                };
              }
            );
          };
        },

        # 0x53 - Back button - Niri window manager controls
        {
          cid: 0x53;
          action: {
            type: "Gestures";
            gestures: (
              {
                direction: "None";
                mode: "OnRelease";
                action: {
                  type: "Keypress";
                  keys: ["KEY_LEFTMETA", "KEY_O"];
                };
              },
              {
                direction: "Up";
                mode: "OnRelease";
                action: {
                  type: "Keypress";
                  keys: ["KEY_LEFTMETA", "KEY_U"];
                };
              },
              {
                direction: "Down";
                mode: "OnRelease";
                action: {
                  type: "Keypress";
                  keys: ["KEY_LEFTMETA", "KEY_I"];
                };
              },
              {
                direction: "Left";
                mode: "OnRelease";
                action: {
                  type: "Keypress";
                  keys: ["KEY_LEFTMETA", "KEY_H"];
                };
              },
              {
                direction: "Right";
                mode: "OnRelease";
                action: {
                  type: "Keypress";
                  keys: ["KEY_LEFTMETA", "KEY_L"];
                };
              }
            );
          };
        },

        # 0xc4 - Gesture button (top) - Media controls
        {
          cid: 0xc4;
          action: {
            type: "Gestures";
            gestures: (
              {
                direction: "None";
                mode: "OnRelease";
                action: {
                  type: "Keypress";
                  keys: ["KEY_PLAYPAUSE"];
                };
              },
              {
                direction: "Up";
                mode: "OnInterval";
                interval: 50;
                action: {
                  type: "Keypress";
                  keys: ["KEY_VOLUMEUP"];
                };
              },
              {
                direction: "Down";
                mode: "OnInterval";
                interval: 50;
                action: {
                  type: "Keypress";
                  keys: ["KEY_VOLUMEDOWN"];
                };
              },
              {
                direction: "Left";
                mode: "OnRelease";
                action: {
                  type: "Keypress";
                  keys: ["KEY_PREVIOUSSONG"];
                };
              },
              {
                direction: "Right";
                mode: "OnRelease";
                action: {
                  type: "Keypress";
                  keys: ["KEY_NEXTSONG"];
                };
              }
            );
          };
        },

        # 0xc3 - Thumb wheel - Toggle hi-res scroll
        {
          cid: 0xc3;
          action: {
            type: "ToggleHiresScroll";
          };
        },
      );
    }
    );
  '';

  # Systemd service for logiops
  systemd.services.logiops = {
    description = "Logitech Configuration Daemon";
    wants = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.logiops}/bin/logid";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
