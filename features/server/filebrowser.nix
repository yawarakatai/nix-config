{ config, pkgs, ... }:

{
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
