{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 8080 ];

  systemd.tmpfiles.rules = [
    "d /data/filebrowser 0755 ${config.my.user.name} users - -"
    "d /storage/shared 0755 ${config.my.user.name} users - -"
  ];

  systemd.services.filebrowser = {
    description = "FileBrowser";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.filebrowser}/bin/filebrowser -d /data/filebrowser/filebrowser.db -r /storage/shared -a 0.0.0.0 -p 8080 -b /files";
      Restart = "on-failure";
      User = config.my.user.name;
      Group = "users";
    };
  };
}
