{ ... }:

{
  programs.niri.settings.binds =
    let
      sh = spawn: [
        "sh"
        "-c"
        spawn
      ];
    in
    {
      "Mod+Shift+Slash".action.show-hotkey-overlay = [ ];
      "Mod+O".action.toggle-overview = [ ];
      "Mod+Tab".action.toggle-overview = [ ];

      # Window management
      "Mod+Q".action.close-window = [ ];
      "Mod+H".action.focus-column-left = [ ];
      "Mod+L".action.focus-column-right = [ ];
      "Mod+J".action.focus-window-or-monitor-down = [ ];
      "Mod+K".action.focus-window-or-monitor-up = [ ];
      "Mod+Shift+H".action.move-column-left = [ ];
      "Mod+Shift+L".action.move-column-right = [ ];
      "Mod+Shift+J".action.move-window-down = [ ];
      "Mod+Shift+K".action.move-window-up = [ ];
      "Mod+Comma".action.move-column-to-first = [ ];
      "Mod+Period".action.move-column-to-last = [ ];

      # Workspaces
      "Mod+1".action.focus-workspace = 1;
      "Mod+2".action.focus-workspace = 2;
      "Mod+3".action.focus-workspace = 3;
      "Mod+4".action.focus-workspace = 4;
      "Mod+5".action.focus-workspace = 5;
      "Mod+Shift+1".action.move-window-to-workspace = 1;
      "Mod+Shift+2".action.move-window-to-workspace = 2;
      "Mod+Shift+3".action.move-window-to-workspace = 3;
      "Mod+Shift+4".action.move-window-to-workspace = 4;
      "Mod+Shift+5".action.move-window-to-workspace = 5;
      "Mod+U".action.focus-workspace-down = [ ];
      "Mod+I".action.focus-workspace-up = [ ];
      "Mod+Shift+U".action.move-column-to-workspace-down = [ ];
      "Mod+Shift+I".action.move-column-to-workspace-up = [ ];

      # Layout
      "Mod+R".action.switch-preset-column-width = [ ];
      "Mod+M".action.maximize-column = [ ];
      "Mod+F".action.fullscreen-window = [ ];

      # Applications
      "Mod+Space".action.spawn = [
        "vicinae"
        "toggle"
      ];
      # "Mod+Space".action.spawn = [ "alacritty" "--class" "floating-term" ];
      "Mod+Return".action.spawn = [ "alacritty" ];
      "Mod+B".action.spawn = [ "firefox" ];
      "Mod+Shift+B".action.spawn = [ "zen" ];
      "Mod+E".action.spawn = [ "nautilus" ];
      "Mod+A".action.spawn = [ "pavucontrol" ];

      # Status notifications (waybar substitution)
      "Mod+T".action.spawn = sh ''
        notify-send -t 3000 "$(date '+%H:%M')" "$(date '+%A, %B %d, %Y')\nWeek $(date '+%V')"
      '';

      "Mod+N".action.spawn = sh ''
        wifi_info=$(nmcli -t -f active,ssid,signal dev wifi | grep '^yes' | cut -d: -f2,3)
        if [ -n "$wifi_info" ]; then
          ssid=$(echo "$wifi_info" | cut -d: -f1)
          signal=$(echo "$wifi_info" | cut -d: -f2)
          ip=$(ip -4 addr show wlan0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1)
          notify-send -t 3000 "󰤨  $ssid" "Signal: $signal%\nIP: ''${ip:-N/A}"
        else
          eth_ip=$(ip -4 addr show enp* 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1)
          if [ -n "$eth_ip" ]; then
            notify-send -t 3000 "󰈀  Ethernet" "IP: $eth_ip"
          else
            notify-send -t 3000 "󰤭  Disconnected" "No network connection"
          fi
        fi
      '';

      "Mod+S".action.spawn = sh ''
        bat_cap=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1)
        bat_status=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -1)
        vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '{print int($2*100)}')
        muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | grep -q MUTED && echo " (muted)" || echo "")
        bright=$(brightnessctl -m 2>/dev/null | cut -d, -f4 | tr -d '%')

        if [ -n "$bat_cap" ]; then
          bat_icon=$([ "$bat_status" = "Charging" ] && echo "󰂄" || echo "󰁹")
          notify-send -t 3000 "$bat_icon Battery: $bat_cap%" "Volume: $vol%$muted\nBrightness: ''${bright:-N/A}%"
        else
          notify-send -t 3000 "󰕾 Volume: $vol%$muted" "Brightness: ''${bright:-N/A}%"
        fi
      '';

      # Screenshot
      "Mod+P".action.spawn =
        sh "f=~/screenshot-$(date +%Y%m%d-%H%M%S).png && grim \"$f\" && notify-send -u low 'Screenshot' \"Saved to $f\"";
      "Mod+Shift+P".action.spawn =
        sh "f=~/screenshot-$(date +%Y%m%d-%H%M%S).png && grim -g \"$(slurp)\" \"$f\" && notify-send -u low 'Screenshot' \"Saved to $f\"";

      # Media
      "XF86AudioPlay".action.spawn = sh "playerctl play-pause";
      "XF86AudioNext".action.spawn = sh "playerctl next";
      "XF86AudioPrev".action.spawn = sh "playerctl previous";
      "XF86AudioStop".action.spawn = sh "playerctl stop";
      "XF86AudioRaiseVolume".action.spawn = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
      "XF86AudioLowerVolume".action.spawn = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
      "XF86AudioMute".action.spawn = sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      "XF86AudioMicMute".action.spawn = sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
      "XF86MonBrightnessUp".action.spawn = sh "brightnessctl set 5%+";
      "XF86MonBrightnessDown".action.spawn = sh "brightnessctl set 5%-";

      # System
      "Mod+Alt+L".action.spawn = sh "swaylock -f -c 000000";
      "Mod+Alt+E".action.quit = [ ];
      "Mod+Alt+S".action.spawn = sh "systemctl suspend";
      "Mod+Alt+R".action.spawn = sh "systemctl reboot";
      "Mod+Alt+P".action.spawn = sh "systemctl poweroff";
    };
}
