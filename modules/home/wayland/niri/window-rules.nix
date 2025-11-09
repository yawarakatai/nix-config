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
      matches = [{ title = "^(Open|Save|Choose).*"; }];
      open-floating = true;
    }
  ];
}
