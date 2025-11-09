{ config, pkgs, vars, ... }:

{
  # Logiops for Logitech device configuration (MX Master 3s)
  environment.systemPackages = with pkgs; [
    logiops
  ];

  # Logiops configuration file
  # To find your device name, run: sudo logid --verbose
  # Common names: "Wireless Mouse MX Master 3S", "MX Master 3S"
  environment.etc."logid.cfg".text = ''
    devices: (
    {
      name: "Wireless Mouse MX Master 3S";

      // Enable smartshift for the scroll wheel
      smartshift: {
        on: true;
        threshold: 15;
      };

      // Enable high-resolution scrolling
      hiresscroll: {
        hires: true;
        invert: false;
        target: false;
      };

      // DPI settings
      dpi: 8000;

      // Button configuration
      buttons: (
        // Thumb wheel (side scroll)
        {
          cid: 0xc3;
          action: {
            type: "Gestures";
            gestures: (
              {
                direction: "Up";
                mode: "OnRelease";
                action: {
                  type: "Keypress";
                  keys: ["KEY_VOLUMEUP"];
                };
              },
              {
                direction: "Down";
                mode: "OnRelease";
                action: {
                  type: "Keypress";
                  keys: ["KEY_VOLUMEDOWN"];
                };
              }
            );
          };
        },

        // Forward button (thumb)
        {
          cid: 0x56;
          action: {
            type: "Keypress";
            keys: ["KEY_FORWARD"];
          };
        },

        // Back button (thumb)
        {
          cid: 0x53;
          action: {
            type: "Keypress";
            keys: ["KEY_BACK"];
          };
        },

        // Gesture button (side button)
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
                  keys: ["KEY_LEFTMETA"];
                };
              },
              {
                direction: "Up";
                mode: "OnRelease";
                action: {
                  type: "Keypress";
                  keys: ["KEY_LEFTMETA", "KEY_D"];
                };
              },
              {
                direction: "Down";
                mode: "OnRelease";
                action: {
                  type: "Keypress";
                  keys: ["KEY_LEFTMETA", "KEY_H"];
                };
              },
              {
                direction: "Left";
                mode: "OnRelease";
                action: {
                  type: "Keypress";
                  keys: ["KEY_LEFTCTRL", "KEY_LEFTALT", "KEY_LEFT"];
                };
              },
              {
                direction: "Right";
                mode: "OnRelease";
                action: {
                  type: "Keypress";
                  keys: ["KEY_LEFTCTRL", "KEY_LEFTALT", "KEY_RIGHT"];
                };
              }
            );
          };
        }
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
