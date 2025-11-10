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
          "pulseaudio"
          "network"
          # "cpu"
          # "memory"
          # "temperature"
          "tray"
        ];

        "niri/workspaces" = {
          format = "{name}";
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

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " Muted";
          format-icons = {
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
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
      
      /* Workspaces */
      #workspaces {
        margin: 0 4px;
      }
      
      #workspaces button {
        padding: 0 8px;
        background-color: ${theme.colorScheme.base01};
        color: ${theme.colorScheme.base05};
        border: ${toString theme.border.width}px solid ${theme.border.inactiveColor};
        margin: 0 2px;
      }
      
      #workspaces button.active {
        background-color: ${theme.colorScheme.base02};
        color: ${theme.semantic.variable};
        border-color: ${theme.border.activeColor};
      }
      
      #workspaces button.urgent {
        background-color: ${theme.semantic.error};
        color: ${theme.colorScheme.base00};
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
      
      /* System modules */
      #cpu,
      #memory,
      #temperature,
      #network,
      #pulseaudio {
        padding: 0 12px;
        background-color: ${theme.colorScheme.base01};
        margin: 0 2px;
      }
      
      #cpu {
        color: ${theme.semantic.success};
      }
      
      #memory {
        color: ${theme.semantic.warning};
      }
      
      #temperature {
        color: ${theme.semantic.info};
      }
      
      #temperature.critical {
        color: ${theme.semantic.error};
        animation: blink 1s linear infinite;
      }
      
      #network {
        color: ${theme.semantic.variable};
      }
      
      #network.disconnected {
        color: ${theme.semantic.error};
      }
      
      #pulseaudio {
        color: ${theme.semantic.function};
      }
      
      #pulseaudio.muted {
        color: ${theme.semantic.comment};
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
