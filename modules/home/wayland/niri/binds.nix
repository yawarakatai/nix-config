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
      # Show help
      "Mod+Shift+Slash".action.show-hotkey-overlay = [ ];

      # Overview
      "Mod+O".action.toggle-overview = [ ];
      "Mod+Tab".action.toggle-overview = [ ];

      # Basic window management
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

      # Workspace cycling
      "Mod+U".action.focus-workspace-down = [ ];
      "Mod+I".action.focus-workspace-up = [ ];
      "Mod+Shift+U".action.move-column-to-workspace-down = [ ];
      "Mod+Shift+I".action.move-column-to-workspace-up = [ ];

      # Sizing
      "Mod+R".action.switch-preset-column-width = [ ];
      "Mod+M".action.maximize-column = [ ];
      # "Mod+F".action.fullscreen-window = [ ];

      # Software
      "Mod+Space".action.spawn = [ "vicinae" "toggle" ];
      "Mod+Return".action.spawn = [ "alacritty" ];
      "Mod+F".action.spawn = [ "firefox" ];
      "Mod+B".action.spawn = [ "brave" ];
      "Mod+E".action.spawn = [ "nautilus" ];
      "Mod+A".action.spawn = [ "pavucontrol" ];

      # Screenshot
      # "Mod+Ctrl+P".action.spawn = sh "grim - | wl-copy && notify-send -u low 'Screenshot' 'Fullscreen copied to clipboard'";
      "Mod+P".action.spawn = sh "f=~/screenshot-$(date +%Y%m%d-%H%M%S).png && grim \"$f\" && notify-send -u low 'Screenshot' \"Saved to $f\"";
      # "Mod+P".acton.spawn = sh "grim -g \"$(slurp)\" - | wl-copy && notify-send -u low 'Screenshot' 'Copied to clipboard'";
      "Mod+Shift+P".action.spawn = sh "f=~/screenshot-$(date +%Y%m%d-%H%M%S).png && grim -g \"$(slurp)\" \"$f\" && notify-send -u low 'Screenshot' \"Saved to $f\"";

      # Media controls
      "XF86AudioPlay".action.spawn = sh "playerctl play-pause";
      "XF86AudioNext".action.spawn = sh "playerctl next";
      "XF86AudioPrev".action.spawn = sh "playerctl previous";
      "XF86AudioStop".action.spawn = sh "playerctl stop";

      # Volume controls
      "XF86AudioRaiseVolume".action.spawn = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
      "XF86AudioLowerVolume".action.spawn = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
      "XF86AudioMute".action.spawn = sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      "XF86AudioMicMute".action.spawn = sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

      # Brightness controls
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
