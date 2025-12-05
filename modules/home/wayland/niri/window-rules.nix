{ ... }:

{
  programs.niri.settings.window-rules = [
    {
      matches = [
        { app-id = "^floating-term$"; }
      ];
      open-floating = true;
    }

    {
      matches = [{ app-id = "^org\\.gnome\\.Nautilus$"; }];
      open-floating = true;
    }

    {
      matches = [
        { app-id = "^org\\.gnome\\.Nautilus$"; }
        { title = "Properties"; }
      ];
      open-floating = true;
    }

    {
      matches = [{ app-id = "^imv$"; }];
      open-floating = true;
    }

    {
      matches = [{ app-id = "org.pulseaudio.pavucontrol"; }];
      open-floating = true;
    }

    {
      matches = [{ title = "^(Open|Save|Choose|Library).*"; }];
      open-floating = true;
    }

    {
      matches = [
        # { app-id = "Godot"; }
        { title = "Godot Engine - Project Manager"; }
      ];
      open-floating = true;
    }

    # Bevy game window
    {
      matches = [
        { app-id = "bevy-game"; }
      ];
      open-floating = true;
    }

    # Enable VRR for games and video players (fixes Chromium 60fps bug)
    {
      matches = [
        { app-id = "^steam_app_.*"; } # Steam games
        { app-id = "^mpv$"; } # MPV video player
        { app-id = "^vlc$"; } # VLC video player
      ];
      variable-refresh-rate = true;
    }
  ];
}
