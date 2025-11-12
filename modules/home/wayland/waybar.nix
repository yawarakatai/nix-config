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
              months = "<span color='${theme.semantic.keyword}'><b>{}</b></span>";
              days = "<span color='${theme.colorScheme.base05}'>{}</span>";
              weeks = "<span color='${theme.semantic.info}'><b>W{}</b></span>";
              weekdays = "<span color='${theme.semantic.warning}'><b>{}</b></span>";
              today = "<span color='${theme.semantic.error}'><b><u>{}</u></b></span>";
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
          format-wifi = " {essid}";
          format-ethernet = " {ifname}";
          format-disconnected = "⚠ Disconnected";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}\n {bandwidthDownBits}  {bandwidthUpBits}";
          interval = 2;
        };

        backlight = {
          format = "{icon}";
          format-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
          tooltip-format = "Brightness: {percent}%";
          on-scroll-up = "brightnessctl set +5%";
          on-scroll-down = "brightnessctl set 5%-";
        };

        pulseaudio = {
          format = "{icon}";
          format-muted = "▁";
          format-icons = {
            default = [ "▁" "▃" "▅" "▇" "█" ];
          };
          tooltip-format = "Volume: {volume}%";
          on-click = "pavucontrol";
          on-scroll-up = "pactl set-sink-volume @DEFAULT_SINK@ +5%";
          on-scroll-down = "pactl set-sink-volume @DEFAULT_SINK@ -5%";
        };

        battery = {
          format = "{icon}";
          format-charging = "⚡";
          format-plugged = "⚡";
          format-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
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
        border-radius: ${toString theme.rounding}px;
        font-family: ${theme.font.family};
        font-size: ${toString theme.font.size}px;
        min-height: 0;
      }
      
      window#waybar {
        background-color: ${theme.colorScheme.base00};
        opacity: ${toString theme.opacity.bar};
        color: ${theme.colorScheme.base05};
      }
      
      /* Workspaces - Circular minimalist design */
      #workspaces {
        margin: 0 4px;
      }

      #workspaces button {
        padding: 0 4px;
        background-color: transparent;
        color: ${theme.colorScheme.base03};
        border: none;
        margin: 0 2px;
        font-size: 18px;
        transition: all 0.2s ease;
      }

      #workspaces button.active {
        color: ${theme.semantic.variable};
        text-shadow: 0 0 8px ${theme.semantic.variable};
      }

      #workspaces button.urgent {
        color: ${theme.semantic.error};
        text-shadow: 0 0 8px ${theme.semantic.error};
      }
      
      /* Window title */
      #window {
        padding: 0 12px;
        color: ${theme.semantic.function};
      }
      
      /* Clock */
      #clock {
        padding: 0 12px;
        color: ${theme.semantic.keyword};
        font-weight: bold;
      }
      
      /* System modules - Minimalist progress bar style */
      #backlight,
      #pulseaudio,
      #battery,
      #network {
        padding: 0 8px;
        background-color: transparent;
        margin: 0 4px;
        font-size: 16px;
      }

      #backlight {
        color: ${theme.semantic.warning};
      }

      #pulseaudio {
        color: ${theme.semantic.function};
      }

      #pulseaudio.muted {
        color: ${theme.colorScheme.base03};
      }

      #battery {
        color: ${theme.semantic.success};
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
        color: ${theme.semantic.info};
      }

      #network {
        color: ${theme.semantic.variable};
      }

      #network.disconnected {
        color: ${theme.semantic.error};
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
