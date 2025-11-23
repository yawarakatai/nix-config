{ ... }:

{
  programs.niri.settings.window-rules = [
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

    # Steam notifications positioning
    {
      matches = [
        { app-id = "^steam$"; }
        { title = "^notificationtoasts_\\d+_desktop$"; }
      ];
      default-floating-position = {
        x = 10;
        y = 10;
        relative-to = "top";
      };
    }
  ];
}
