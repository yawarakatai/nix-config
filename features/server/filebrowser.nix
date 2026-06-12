{ config, pkgs, ... }:

{
  # Ensure /data/filebrowser exists with correct permissions
  systemd.tmpfiles.rules = [
    "d /data/filebrowser 0755 ${config.my.user.name} users - -"
  ];

  systemd.services.filebrowser = {
    description = "FileBrowser";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.filebrowser}/bin/filebrowser -d /data/filebrowser/filebrowser.db -r /data -a 0.0.0.0 -p 8080";
      Restart = "on-failure";
      User = config.my.user.name;
      Group = "users";
    };
  };
}
