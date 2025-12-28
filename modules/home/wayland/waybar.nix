{ config, pkgs, uiSettings, vars, ... }:

{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 8;

        modules-left = [ "niri/workspaces" "niri/window" ];
        modules-center = [ "clock" ];
        modules-right = [
          "backlight"
          "pulseaudio"
          "battery"
          "network"
          "tray"
        ];

        "niri/workspaces" = {
          format = "●";
          on-click = "activate";
        };

        "niri/window" = {
          format = "{}";
          max-length = 50;
          separate-outputs = true;
        };

        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%A, %B %d, %Y}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            # Colors will be configured by stylix
          };
        };

        network = {
          format-wifi = "{icon}";
          format-ethernet = "󰈀";
          format-disconnected = "󰤭";
          format-icons = [ "󰤟" "󰤢" "󰤥" "󰤨" ];
          tooltip-format-wifi = "WiFi: {essid}\nSignal: {signalStrength}%\nIP: {ipaddr}/{cidr}\n {bandwidthDownBits}  {bandwidthUpBits}";
          tooltip-format-ethernet = "Ethernet: {ifname}\nIP: {ipaddr}/{cidr}\n {bandwidthDownBits}  {bandwidthUpBits}";
          tooltip-format-disconnected = "Network Disconnected";
          interval = 2;
        };

        backlight = {
          format = "{icon}";
          format-icons = [ "󰃞" "󰃟" "󰃠" ];
          tooltip-format = "Brightness: {percent}%";
          on-scroll-up = "brightnessctl set +5%";
          on-scroll-down = "brightnessctl set 5%-";
        };

        pulseaudio = {
          format = "{icon}";
          format-muted = "󰖁";
          format-icons = {
            default = [ "󰕿" "󰖀" "󰕾" ];
          };
          tooltip-format = "Volume: {volume}%";
          on-click = "pavucontrol";
          on-scroll-up = "pactl set-sink-volume @DEFAULT_SINK@ +5%";
          on-scroll-down = "pactl set-sink-volume @DEFAULT_SINK@ -5%";
        };

        battery = {
          format = "{icon}";
          format-charging = "󰂄";
          format-plugged = "󰚥";
          format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          tooltip-format = "Battery: {capacity}%\n{timeTo}";
          states = {
            warning = 30;
            critical = 15;
          };
        };

        tray = {
          icon-size = 16;
          spacing = 8;
        };
      };
    };

    # Style - colors/fonts will be configured by stylix
    style = ''
      * {
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        opacity: ${toString uiSettings.opacity.bar};
      }

      /* Workspaces - Horizontal indicators */
      #workspaces {
        margin: 0 4px;
      }

      #workspaces button {
        padding: 0 8px;
        background-color: transparent;
        border: none;
        border-bottom: 2px solid transparent;
        margin: 0 2px;
        font-size: 18px;
        transition: all 0.2s ease;
      }

      /* Window title */
      #window {
        padding: 0 12px;
      }

      /* Clock */
      #clock {
        padding: 0 12px;
        font-weight: bold;
      }

      /* System modules - Horizontal bar indicators */
      #backlight,
      #pulseaudio,
      #battery,
      #network {
        padding: 0 12px;
        background-color: transparent;
        margin: 0 4px;
        font-size: 16px;
      }

      #tray {
        padding: 0 8px;
      }

      /* Animations */
      @keyframes blink {
        50% {
          opacity: 0.5;
        }
      }
    '';
  };
}
