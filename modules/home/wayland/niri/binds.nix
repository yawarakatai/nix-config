{ ... }:

{
  programs.niri.settings.binds =
    let
      sh = spawn: [ "sh" "-c" spawn ];
    in
    {
      # Basic window management
      "Mod+Return".action.spawn = "alacritty";
      "Mod+Q".action.close-window = [ ];
      "Mod+H".action.focus-column-left = [ ];
      "Mod+L".action.focus-column-right = [ ];
      "Mod+J".action.focus-window-down = [ ];
      "Mod+K".action.focus-window-up = [ ];
      "Mod+Shift+H".action.move-column-left = [ ];
      "Mod+Shift+L".action.move-column-right = [ ];
      "Mod+Shift+J".action.move-window-down = [ ];
      "Mod+Shift+K".action.move-window-up = [ ];
      "Mod+O".action.toggle-overview = [ ];

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
      "Mod+Tab".action.focus-workspace-down = [ ];
      "Mod+Shift+Tab".action.focus-workspace-up = [ ];

      # Sizing
      "Mod+R".action.switch-preset-column-width = [ ];
      "Mod+F".action.maximize-column = [ ];
      "Mod+Shift+F".action.fullscreen-window = [ ];

      # Launcher
      "Mod+Space".action.spawn = [ "anyrun" ];

      # Applications
      "Mod+B".action.spawn = [ "firefox" ];
      "Mod+E".action.spawn = [ "nautilus" ];
      "Mod+A".action.spawn = [ "pavucontrol" ];

      # Screenshot
      "Print".action.spawn = [ "grimblast" "copy" "area" ];
      "Shift+Print".action.spawn = [ "grimblast" "save" "area" ];
      "Ctrl+Print".action.spawn = [ "grimblast" "copy" "screen" ];
      "Ctrl+Shift+Print".action.spawn = [ "grimblast" "save" "screen" ];
      "Alt+Print".action.spawn = [ "grimblast" "copy" "window" ];

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
      "Mod+Shift+E".action.quit = [ ];
      "Mod+Escape".action.spawn = sh "swaylock -f -c 000000";
    };
}
