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
              months = "<span color='${theme.colorScheme.base07}'><b>{}</b></span>";
              days = "<span color='${theme.colorScheme.base05}'>{}</span>";
              # weeks = "<span color='${theme.colorScheme.base04}'><b>W{}</b></span>";
              weekdays = "<span color='${theme.colorScheme.base05}'><b>{}</b></span>";
              today = "<span color='${theme.colorScheme.base07}'><b><u>{}</u></b></span>";
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
        background-color: ${theme.colorScheme.base00};
        opacity: ${toString theme.opacity.bar};
        color: ${theme.colorScheme.base07};
      }

      /* Workspaces - Horizontal indicators */
      #workspaces {
        margin: 0 4px;
      }

      #workspaces button {
        padding: 0 8px;
        background-color: transparent;
        color: ${theme.colorScheme.base03};
        border: none;
        border-bottom: 2px solid transparent;
        margin: 0 2px;
        font-size: 18px;
        transition: all 0.2s ease;
      }

      #workspaces button.active {
        color: ${theme.colorScheme.base07};
        border-bottom: 2px solid ${theme.colorScheme.base07};
        background-color: ${theme.colorScheme.base02};
      }

      #workspaces button.urgent {
        color: ${theme.colorScheme.base05};
        border-bottom: 2px solid ${theme.colorScheme.base05};
        animation: blink 1s linear infinite;
      }

      /* Window title */
      #window {
        padding: 0 12px;
        color: ${theme.colorScheme.base05};
      }

      /* Clock */
      #clock {
        padding: 0 12px;
        color: ${theme.colorScheme.base07};
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
        color: ${theme.colorScheme.base07};
        border-left: 1px solid ${theme.colorScheme.base02};
      }

      #backlight {
        color: ${theme.colorScheme.base07};
      }

      #pulseaudio {
        color: ${theme.colorScheme.base07};
      }

      #pulseaudio.muted {
        color: ${theme.colorScheme.base03};
      }

      #battery {
        color: ${theme.colorScheme.base07};
      }

      #battery.warning:not(.charging) {
        color: ${theme.semantic.warning};
      }

      #battery.critical:not(.charging) {
        color: ${theme.semantic.error};
        animation: blink 1s linear infinite;
      }

      #battery.charging,
      #battery.plugged {
        color: ${theme.semantic.success};
      }

      #network {
        color: ${theme.colorScheme.base07};
      }

      #network.disconnected {
        color: ${theme.colorScheme.base03};
      }

      #tray {
        padding: 0 8px;
        border-left: 1px solid ${theme.colorScheme.base02};
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
