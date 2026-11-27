{
  pkgs,
  ...
}:

let
  forceCloseWindow = pkgs.writeShellApplication {
    name = "force-close-window";
    runtimeInputs = [
      pkgs.jq
      pkgs.libnotify
      pkgs.niri
    ];
    text = ''
      if ! pid="$(niri msg --json focused-window | jq -er '.pid')"; then
        notify-send -u low "Force close" "No focused window with a process ID"
        exit 1
      fi

      kill -KILL "$pid"
    '';
  };
in
{
  home.packages = [ forceCloseWindow ];

  wayland.windowManager.niri.settings.binds =
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

      "Mod+Shift+Slash".show-hotkey-overlay = { };
      "Mod+Tab".toggle-overview = { };

      # --- Window management (neio) ---
      "Mod+Q".close-window = { };
      "Mod+N".focus-column-left = { };
      "Mod+O".focus-column-right = { };
      "Mod+E".focus-window-or-monitor-down = { };
      "Mod+I".focus-window-or-monitor-up = { };
      "Mod+Shift+N".move-column-left = { };
      "Mod+Shift+O".move-column-right = { };
      "Mod+Shift+E".move-window-down = { };
      "Mod+Shift+I".move-window-up = { };
      "Mod+Comma".swap-window-left = { };
      "Mod+Period".swap-window-right = { };
      "Mod+F".toggle-window-floating = { };

      # --- Workspaces ---
      # Workspaces are dynamic: declaring named ones would keep them when emptied
      # and leave gaps, while unnamed ones are removed so the rest close up.
      # These binds target indices, so they keep working as workspaces shift.
      "Mod+1".focus-workspace = 1;
      "Mod+2".focus-workspace = 2;
      "Mod+3".focus-workspace = 3;
      "Mod+4".focus-workspace = 4;
      "Mod+5".focus-workspace = 5;
      "Mod+Shift+1".move-window-to-workspace = 1;
      "Mod+Shift+2".move-window-to-workspace = 2;
      "Mod+Shift+3".move-window-to-workspace = 3;
      "Mod+Shift+4".move-window-to-workspace = 4;
      "Mod+Shift+5".move-window-to-workspace = 5;

      # Workspace navigation: u/y (below neio row, easy reach)
      "Mod+U".focus-workspace-down = { };
      "Mod+Y".focus-workspace-up = { };
      "Mod+Shift+U".move-column-to-workspace-down = { };
      "Mod+Shift+Y".move-column-to-workspace-up = { };

      # --- Layout ---
      "Mod+W".switch-preset-column-width = { };
      "Mod+M".maximize-column = { };

      # --- Applications ---
      "Mod+Space".spawn = sh "noctalia msg panel-toggle launcher";
      "Mod+D".spawn = sh "noctalia msg panel-toggle control-center";
      "Mod+Return".spawn = sh "exec ghostty +new-window --working-directory=\"$HOME\"";
      "Mod+B".spawn = [ "zen-beta" ];
      "Mod+H".spawn = [ "nautilus" ];

      # --- Screenshot ---
      "Mod+S".screenshot = { };
      "Mod+Shift+S".screenshot-screen = { };

      # --- Media ---
      "XF86AudioPlay".spawn = sh "playerctl play-pause";
      "XF86AudioNext".spawn = sh "playerctl next";
      "XF86AudioPrev".spawn = sh "playerctl previous";
      "XF86AudioStop".spawn = sh "playerctl stop";
      "XF86AudioRaiseVolume".spawn = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
      "XF86AudioLowerVolume".spawn = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
      "XF86AudioMute".spawn = sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      "XF86AudioMicMute".spawn = sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
      "XF86MonBrightnessUp".spawn = sh "brightnessctl set 5%+";
      "XF86MonBrightnessDown".spawn = sh "brightnessctl set 5%-";

      # --- System ---
      "Mod+Shift+Q".spawn = [ "force-close-window" ];
      "Mod+Escape".spawn = sh "noctalia msg panel-toggle session";
    };
}
