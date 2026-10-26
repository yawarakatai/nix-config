_:

{
  systemd.user.services.steam = {
    Unit = {
      Description = "Start Steam silently in the system tray";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      # Use the NixOS wrapper to retain its compatibility packages and settings.
      ExecStart = "/run/current-system/sw/bin/steam -silent";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
