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
        hires: true;
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

        # Forward button (thumb)
        {
          cid: 0x56;
          action: {
            type: "Keypress";
            keys: ["KEY_FORWARD"];
          };
        },

        # Back button (thumb)
        {
          cid: 0x53;
          action: {
            type: "Keypress";
            keys: ["KEY_BACK"];
          };
        },

        # Gesture button (top)
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

        # Gesture button (bottom)
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
                  keys: [];
                };
              },
              {
                direction: "Down";
                mode: "OnRelease";
                action: {
                  type: "Keypress";
                  keys: [];
                };
              }
            );
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
