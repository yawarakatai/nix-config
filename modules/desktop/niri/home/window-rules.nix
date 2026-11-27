_:

let
  # Each match is its own node; a window matches the rule if it matches any of them.
  rule = matches: settings: {
    window-rule = settings // {
      _children = map (match: { match._props = match; }) matches;
    };
  };
in
{
  wayland.windowManager.niri.settings._children = [
    (rule [ { title = "^(Open|Save|Choose|Library).*"; } ] { open-floating = true; })

    # PIP window
    (rule [ { title = "^Picture-in-Picture$"; } ] {
      open-floating = true;
      default-column-width.proportion = 0.25;
    })

    # Nautilus opens centered by default when floating.
    (rule [ { app-id = "^org\\.gnome\\.Nautilus$"; } ] {
      open-floating = true;
      default-column-width.proportion = 0.5;
      default-window-height.proportion = 0.5;
    })

    # Fcitx5 Config
    (rule [ { app-id = "org.fcitx.fcitx5-config-qt"; } ] { open-floating = true; })

    # KiCad
    (rule [ { app-id = "kicad"; } ] { open-floating = true; })

    (rule [
      {
        app-id = "kicad";
        title = ".*(KiCad|Schematic Editor|PCB Editor).*";
      }
    ] { open-floating = false; })

    # Godot Engine
    # (rule [
    #   {
    #     app-id = "^Godot$";
    #     title = "^Godot Engine - Project Manager$";
    #   }
    # ] { open-floating = true; })

    # Davinci Resolve
    (rule [
      { title = "Project Manager"; }
      { app-id = "resolve"; }
    ] { open-floating = true; })

    # Bevy game window
    (rule [ { app-id = "bevy-game"; } ] { open-floating = true; })

    # Steam emulates some menus inside its Xwayland surface. Clipping the
    # surface to rounded geometry makes those menus disappear or lose input.
    (rule [ { app-id = "^steam$"; } ] {
      open-fullscreen = false;
      clip-to-geometry = false;
    })

    # Enable VRR for games and video players (fixes Chromium 60fps bug)
    (rule [
      { app-id = "^steam_app_.*"; } # Steam games
      { app-id = "^mpv$"; } # MPV video player
      { app-id = "^vlc$"; } # VLC video player
    ] { variable-refresh-rate = true; })
  ];
}
