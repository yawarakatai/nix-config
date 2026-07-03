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
      # =============================================
      #  Colemak DH keybindings
      #
      #  Movement (neio):
      #    n = left    e = down    i = up    o = right
      # =============================================

      "Mod+Shift+Slash".action.show-hotkey-overlay = [ ];
      "Mod+Tab".action.toggle-overview = [ ];

      # --- Window management (neio) ---
      "Mod+Q".action.close-window = [ ];
      "Mod+N".action.focus-column-left = [ ];
      "Mod+O".action.focus-column-right = [ ];
      "Mod+E".action.focus-window-or-monitor-down = [ ];
      "Mod+I".action.focus-window-or-monitor-up = [ ];
      "Mod+Shift+N".action.move-column-left = [ ];
      "Mod+Shift+O".action.move-column-right = [ ];
      "Mod+Shift+E".action.move-window-down = [ ];
      "Mod+Shift+I".action.move-window-up = [ ];
      "Mod+Comma".action.move-column-to-first = [ ];
      "Mod+Period".action.move-column-to-last = [ ];

      # --- Workspaces ---
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

      # Workspace navigation: u/y (below neio row, easy reach)
      "Mod+U".action.focus-workspace-down = [ ];
      "Mod+Y".action.focus-workspace-up = [ ];
      "Mod+Shift+U".action.move-column-to-workspace-down = [ ];
      "Mod+Shift+Y".action.move-column-to-workspace-up = [ ];

      # --- Layout ---
      "Mod+T".action.switch-preset-column-width = [ ];
      "Mod+M".action.maximize-column = [ ];
      "Mod+W".action.fullscreen-window = [ ];

      # --- Applications ---
      "Mod+Space".action.spawn = sh "noctalia msg panel-toggle launcher";
      "Mod+D".action.spawn = sh "noctalia msg panel-toggle control-center home";
      "Mod+Return".action.spawn = sh "exec ghostty --working-directory=\"$HOME\"";
      "Mod+B".action.spawn = [ "zen-beta" ];
      "Mod+F".action.spawn = [ "nautilus" ];
      "Mod+A".action.spawn = [ "pavucontrol" ];

      # --- Screenshot ---
      "Mod+S".action.spawn =
        sh "f=~/screenshot-$(date +%Y%m%d-%H%M%S).png && grim \"$f\" && notify-send -u low 'Screenshot' \"Saved to $f\"";
      "Mod+Shift+S".action.spawn =
        sh "f=~/screenshot-$(date +%Y%m%d-%H%M%S).png && grim -g \"$(slurp)\" \"$f\" && notify-send -u low 'Screenshot' \"Saved to $f\"";

      # --- Media ---
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

      # --- System ---
      "Mod+Escape".action.spawn = sh "noctalia msg panel-toggle session";
    };
}
