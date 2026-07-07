{
  pkgs,
  username,
  ...
}:

{
  systemd.tmpfiles.rules = [
    "d /data/filebrowser 0755 ${username} users - -"
    "d /storage/shared 0755 ${username} users - -"
  ];

  systemd.services.filebrowser = {
    description = "FileBrowser";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.filebrowser}/bin/filebrowser -d /data/filebrowser/filebrowser.db -r /storage/shared -a 127.0.0.1 -p 8080 -b /files";
      Restart = "on-failure";
      User = username;
      Group = "users";
    };
  };
}
