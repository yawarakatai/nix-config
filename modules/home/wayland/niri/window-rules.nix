{ ... }:

{
  programs.niri.settings.window-rules = [
    {
      matches = [{ app-id = "^org\\.gnome\\.Nautilus$"; }];
      open-floating = true;
      default-column-width = { proportion = 0.6; };
    }

    {
      matches = [
        { app-id = "^org\\.gnome\\.Nautilus$"; }
        { title = "Properties"; }
      ];
      open-floating = true;
      default-column-width = { proportion = 0.3; };
    }

    {
      matches = [{ app-id = "^imv$"; }];
      open-floating = true;
      default-column-width = { proportion = 0.5; };
    }

    {
      matches = [{ app-id = "org.pulseaudio.pavucontrol"; }];
      open-floating = true;
      default-column-width = { proportion = 0.4; };
    }

    {
      matches = [{ title = "^(Open|Save|Choose|Library).*"; }];
      open-floating = true;
    }

    # Steam main window
    {
      matches = [{ app-id = "^steam$"; }];
      open-floating = true;
      default-column-width = { proportion = 0.7; };
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
        relative-to = "bottom-right";
      };
    }
  ];
}
