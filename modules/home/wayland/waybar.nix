{ config, pkgs, theme, vars, ... }:

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
            format = {
              months = "<span color='#ffffff'><b>{}</b></span>";
              days = "<span color='#cccccc'>{}</span>";
              weeks = "<span color='#999999'><b>W{}</b></span>";
              weekdays = "<span color='#cccccc'><b>{}</b></span>";
              today = "<span color='#ffffff'><b><u>{}</u></b></span>";
            };
          };
        };

        # cpu = {
        #   format = "CPU {usage}%";
        #   tooltip = true;
        #   interval = 2;
        # };

        # memory = {
        #   format = "RAM {percentage}%";
        #   tooltip-format = "RAM: {used:0.1f}G / {total:0.1f}G\nSwap: {swapUsed:0.1f}G / {swapTotal:0.1f}G";
        #   interval = 2;
        # };

        # temperature = {
        #   critical-threshold = 80;
        #   format = "{temperatureC}°C";
        #   format-critical = "{temperatureC}°C ";
        #   interval = 2;
        # };

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

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: ${theme.font.family};
        font-size: ${toString theme.font.size}px;
        min-height: 0;
      }

      window#waybar {
        background-color: #000000;
        opacity: 0.95;
        color: #ffffff;
      }

      /* Workspaces - Horizontal indicators */
      #workspaces {
        margin: 0 4px;
      }

      #workspaces button {
        padding: 0 8px;
        background-color: transparent;
        color: #666666;
        border: none;
        border-bottom: 2px solid transparent;
        margin: 0 2px;
        font-size: 18px;
        transition: all 0.2s ease;
      }

      #workspaces button.active {
        color: #ffffff;
        border-bottom: 2px solid #ffffff;
        background-color: #333333;
      }

      #workspaces button.urgent {
        color: #cccccc;
        border-bottom: 2px solid #cccccc;
        animation: blink 1s linear infinite;
      }

      /* Window title */
      #window {
        padding: 0 12px;
        color: #cccccc;
      }

      /* Clock */
      #clock {
        padding: 0 12px;
        color: #ffffff;
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
        color: #ffffff;
        border-left: 1px solid #333333;
      }

      #backlight {
        color: #ffffff;
      }

      #pulseaudio {
        color: #ffffff;
      }

      #pulseaudio.muted {
        color: #666666;
      }

      #battery {
        color: #ffffff;
      }

      #battery.warning:not(.charging) {
        color: #cccccc;
      }

      #battery.critical:not(.charging) {
        color: #999999;
        animation: blink 1s linear infinite;
      }

      #battery.charging,
      #battery.plugged {
        color: #ffffff;
      }

      #network {
        color: #ffffff;
      }

      #network.disconnected {
        color: #666666;
      }

      #tray {
        padding: 0 8px;
        border-left: 1px solid #333333;
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
