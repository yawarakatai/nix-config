{ ... }:

{
  programs.waybar = {
    enable = true;

    settings.mainBar = {
      layer = "top";
      position = "top";
      margin-left = 5;
      margin-right = 5;
      margin-top = 4;

      modules-left = [
        "niri/workspaces"
      ];

      modules-center = [
        "niri/window"
      ];

      modules-right = [
        "tray"
        "bluetooth"
        "network"
        "pulseaudio"
        "memory"
        "cpu"
        "battery"
        "clock"
      ];

      "niri/workspaces" = {
        format = "{icon}";
        disable-scroll = true;
        all-outputs = true;
        format-icons = {
          active = "󰮯";
          default = "󰊠";
          empty = "󱙝";
        };
      };

      "niri/window" = {
        format = "{title}";
        max-length = 40;
      };

      clock = {
        format = "{:%H:%M}";
        interval = 60;
        tooltip-format = "<span>{calendar}</span>";
        calendar = {
          mode = "month";
          mode-mon-col = 2;
          format = {
            month = "<span color='#f6c177'><b>{}</b></span>";
            weekdays = "<span color='#c4a7e7'><b>{}</b></span>";
            today = "<span color='#eb6f92'><b>{}</b></span>";
          };
        };
      };

      memory = {
        interval = 5;
        format = "MEM {icon} {percentage:02}%";
        format-icons = [
          "<span size='10pt'>░░░░░░</span>"
          "<span size='10pt'>█░░░░░</span>"
          "<span size='10pt'>██░░░░</span>"
          "<span size='10pt'>███░░░</span>"
          "<span size='10pt'>████░░</span>"
          "<span size='10pt'>█████░</span>"
          "<span size='10pt'>██████</span>"
        ];
      };

      cpu = {
        interval = 5;
        format = "CPU {icon} {usage:02}%";
        format-icons = [
          "<span size='10pt'>░░░░░░</span>"
          "<span size='10pt'>█░░░░░</span>"
          "<span size='10pt'>██░░░░</span>"
          "<span size='10pt'>███░░░</span>"
          "<span size='10pt'>████░░</span>"
          "<span size='10pt'>█████░</span>"
          "<span size='10pt'>██████</span>"
        ];
      };

      pulseaudio = {
        format = "VOL {icon} {volume}%";
        format-muted = "VOL 󰖁 MUTED";
        format-icons = [
          "<span size='10pt'>░░░░░░</span>"
          "<span size='10pt'>█░░░░░</span>"
          "<span size='10pt'>██░░░░</span>"
          "<span size='10pt'>███░░░</span>"
          "<span size='10pt'>████░░</span>"
          "<span size='10pt'>█████░</span>"
          "<span size='10pt'>██████</span>"
        ];
        on-click = "pavucontrol";
        on-click-right = "pamixer -t";
      };

      tray = {
        icon-size = 13;
        spacing = 4;
      };

      bluetooth = {
        format = "BT{num_connections}";
        format-disabled = "";
        format-off = "BT";
        format-connected = "BT{num_connections}";
        tooltip-format = "Devices: {num_connections}";
      };

      network = {
        format-wifi = "  {essid}";
        format-ethernet = "  {ifname}";
        format-disconnected = "󰤭";
        tooltip-format-wifi = "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes} ⇡{bandwidthUpBytes}";
        tooltip-format-disconnected = "Disconnected";
      };

      battery = {
        format = "BAT {capacity}%";
        format-charging = "BAT {capacity}%";
        format-plugged = "";
        format-full = "BAT FULL";
        format-icons = {
          charging = [
            "󰢜"
            "󰂆"
            "󰂇"
            "󰂈"
            "󰢝"
            "󰂉"
            "󰢞"
            "󰂊"
            "󰂋"
            "󰂅"
          ];
          default = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };
        states = {
          warning = 20;
          critical = 10;
        };
      };

      style = ''
        * {
          font-size: 11pt;
          font-family: "JetBrainsMono NL Nerd Font";
          min-height: 0;
        }

        window#waybar {
          background: transparent;
          color: @base05;
        }

        #workspaces {
          background: alpha(@base00, 0.5);
          border-radius: 8px;
          padding: 0 4px;
          margin: 2px 4px;
        }

        #workspaces button {
          padding: 2px 6px;
          color: @base04;
        }

        #workspaces button.active {
          color: @base06;
        }

        #window {
          background: alpha(@base00, 0.5);
          border-radius: 8px;
          padding: 0 12px;
          margin: 2px 4px;
        }

        #tray,
        #bluetooth,
        #network,
        #pulseaudio,
        #memory,
        #cpu,
        #battery,
        #clock {
          background: alpha(@base00, 0.5);
          border-radius: 8px;
          padding: 0 10px;
          margin: 2px 2px;
        }

        #clock {
          font-weight: bold;
        }

        #battery.warning {
          color: @base09;
        }

        #battery.critical {
          color: @base08;
        }

        #network.disconnected {
          color: @base08;
        }

        tooltip {
          background: alpha(@base00, 0.9);
          border: 1px solid @base02;
          border-radius: 8px;
        }
      '';
    };
  };
}
