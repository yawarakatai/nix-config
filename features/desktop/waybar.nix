{ osConfig, ... }:

{
  programs.waybar = {
    enable = true;

    settings.mainBar = {
      layer = "top";
      position = "top";
      margin-left = osConfig.my.theme.gaps;
      margin-right = osConfig.my.theme.gaps;
      margin-top = osConfig.my.theme.gaps;

      modules-left = [
        "niri/workspaces"
      ];

      modules-center = [
        "clock"
      ];

      modules-right = [
        "custom/recording"
        "tray"
        "bluetooth"
        "network"
        "backlight"
        "pulseaudio"
        "cpu"
        "memory"
        "battery"
        "custom/power"
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

      backlight = {
        format = "BRT {icon}";
        format-icons = [
          "<span size='10pt' color='#6e6a86'>░░░░░░</span>"
          "<span size='10pt' color='#f6c177'>█░░░░░</span>"
          "<span size='10pt' color='#f6c177'>██░░░░</span>"
          "<span size='10pt' color='#f6c177'>███░░░</span>"
          "<span size='10pt' color='#f6c177'>████░░</span>"
          "<span size='10pt' color='#f6c177'>█████░</span>"
          "<span size='10pt' color='#f6c177'>██████</span>"
        ];
        on-scroll-up = "brightnessctl s 5%+";
        on-scroll-down = "brightnessctl s 5%-";
        tooltip-format = "Brightness: {percent}%";
      };

      memory = {
        interval = 5;
        format = "MEM {icon}";
        format-icons = [
          "<span size='10pt' color='#6e6a86'>░░░░░░</span>"
          "<span size='10pt' color='#c4a7e7'>█░░░░░</span>"
          "<span size='10pt' color='#c4a7e7'>██░░░░</span>"
          "<span size='10pt' color='#c4a7e7'>███░░░</span>"
          "<span size='10pt' color='#c4a7e7'>████░░</span>"
          "<span size='10pt' color='#c4a7e7'>█████░</span>"
          "<span size='10pt' color='#c4a7e7'>██████</span>"
        ];
        on-click = "btop";
        tooltip-format = "{percentage}%";
      };

      cpu = {
        interval = 5;
        format = "CPU {icon}";
        format-icons = [
          "<span size='10pt' color='#6e6a86'>░░░░░░</span>"
          "<span size='10pt' color='#ebbcba'>█░░░░░</span>"
          "<span size='10pt' color='#ebbcba'>██░░░░</span>"
          "<span size='10pt' color='#ebbcba'>███░░░</span>"
          "<span size='10pt' color='#ebbcba'>████░░</span>"
          "<span size='10pt' color='#ebbcba'>█████░</span>"
          "<span size='10pt' color='#ebbcba'>██████</span>"
        ];
        on-click = "btop";
        tooltip-format = "{usage}%";
      };

      pulseaudio = {
        format = "VOL {icon}";
        format-muted = "VOL 󰖁";
        format-icons = [
          "<span size='10pt' color='#6e6a86'>░░░░░░</span>"
          "<span size='10pt' color='#9ccfd8'>█░░░░░</span>"
          "<span size='10pt' color='#9ccfd8'>██░░░░</span>"
          "<span size='10pt' color='#9ccfd8'>███░░░</span>"
          "<span size='10pt' color='#9ccfd8'>████░░</span>"
          "<span size='10pt' color='#9ccfd8'>█████░</span>"
          "<span size='10pt' color='#9ccfd8'>██████</span>"
        ];
        on-click = "pavucontrol";
        on-click-right = "pamixer -t";
        tooltip-format = "{volume}%";
      };

      battery = {
        format = "BAT {icon}";
        format-plugged = "BAT ";
        format-full = "BAT ";
        format-icons = [
          "<span size='10pt' color='#6e6a86'>░░░░░░</span>"
          "<span size='10pt' color='#a3be8c'>█░░░░░</span>"
          "<span size='10pt' color='#a3be8c'>██░░░░</span>"
          "<span size='10pt' color='#a3be8c'>███░░░</span>"
          "<span size='10pt' color='#a3be8c'>████░░</span>"
          "<span size='10pt' color='#a3be8c'>█████░</span>"
          "<span size='10pt' color='#a3be8c'>██████</span>"
        ];
        states = {
          warning = 20;
          critical = 10;
        };
        tooltip-format = "{capacity}% - {timeTo}";
      };

      "custom/recording" = {
        exec = "recording-indicator";
        interval = 2;
        return-type = "json";
        on-click = "toggle-recording";
        tooltip-format = "{tooltip}";
      };

      "custom/power" = {
        format = " ⏻ ";
        on-click = "wlogout";
        tooltip-format = "Power Menu (Logout/Reboot/Shutdown)";
      };

      tray = {
        icon-size = 13;
        spacing = 4;
      };

      bluetooth = {
        format = "󰂯 {num_connections}";
        format-disabled = "";
        format-off = "󰂲";
        format-connected = "󰂯 {num_connections}";
        tooltip-format = "Devices: {num_connections}";
        on-click = "blueman-manager";
      };

      network = {
        format-wifi = "  {essid}";
        format-ethernet = "󰈀  {ifname}";
        format-disconnected = "󰤭";
        tooltip-format-wifi = "{essid} ({frequency} GHz) - ⇣{bandwidthDownBytes} ⇡{bandwidthUpBytes}";
        tooltip-format-disconnected = "Disconnected";
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

        #clock {
          background: alpha(@base00, 0.5);
          border-radius: 8px;
          padding: 0 12px;
          margin: 2px 4px;
          font-weight: bold;
          font-size: 12pt;
        }

        #custom-recording,
        #tray,
        #bluetooth,
        #network,
        #backlight,
        #pulseaudio,
        #memory,
        #cpu,
        #battery {
          background: alpha(@base00, 0.5);
          border-radius: 8px;
          padding: 0 10px;
          margin: 2px 2px;
        }

        #custom-recording.recording {
          background: alpha(@base08, 0.8);
          color: @base00;
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
          border: none;
          border-radius: 8px;
          padding: 4px 8px;
        }
      '';
    };
  };
}
