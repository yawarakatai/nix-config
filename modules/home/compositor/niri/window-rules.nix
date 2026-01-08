{ ... }:

{
  programs.niri.settings.window-rules = [
    {
      matches = [
        { app-id = "^floating-term$"; }
      ];
      open-floating = true;
      opacity = 0.95;
    }

    {
      matches = [ { app-id = "^org\\.gnome\\.Nautilus$"; } ];
      open-floating = true;
    }

    {
      matches = [ { app-id = "^imv$"; } ];
      open-floating = true;
    }

    {
      matches = [ { app-id = "org.pulseaudio.pavucontrol"; } ];
      open-floating = true;
    }

    {
      matches = [ { title = "^(Open|Save|Choose|Library).*"; } ];
      open-floating = true;
    }

    # PIP window
    {
      matches = [
        { title = "^Picture-in-Picture$"; }
      ];
      open-floating = true;
      default-column-width = {
        proportion = 0.25;
      };
    }

    # Fcitx5 Config
    {
      matches = [ { app-id = "org.fcitx.fcitx5-config-qt"; } ];
      open-floating = true;
    }

    # Authentication
    {
      matches = [
        { app-id = "^org\\.gnome\\.Polkit.*"; } # Polkit agent
        { app-id = "^lxqt-policykit-agent$"; }
      ];
      open-floating = true;
      default-column-width = {
        fixed = 600;
      };
    }

    # KiCad
    {
      matches = [ { app-id = "kicad"; } ];
      open-floating = true;
    }

    {
      matches = [
        {
          app-id = "kicad";
          title = ".*(KiCad|Schematic Editor|PCB Editor).*";
        }
      ];
      open-floating = false;
    }

    # Godot Engine
    # {
    #   matches = [
    #     {
    #       app-id = "^Godot$";
    #       title = "^Godot Engine - Project Manager$";
    #     }
    #   ];
    #   open-floating = true;
    # }

    # Davinci Resolve
    {
      matches = [
        { title = "Project Manager"; }
        { app-id = "resolve"; }
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
