{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 8080 ];

  systemd.tmpfiles.rules = [
    "d /data/filebrowser 0755 ${config.my.user.name} users - -"
    "d /data/shared 0755 ${config.my.user.name} users - -"
  ];

  systemd.services.filebrowser = {
    description = "FileBrowser";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.filebrowser}/bin/filebrowser -d /data/filebrowser/filebrowser.db -r /data/shared -a 0.0.0.0 -p 8080 -b /files";
      Restart = "on-failure";
      User = config.my.user.name;
      Group = "users";
    };
  };

  systemd.services.tailscale-serve-filebrowser = {
    wantedBy = [ "multi-user.target" ];
    after = [ "tailscaled.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      ${pkgs.tailscale}/bin/tailscale serve --bg --set-path /files 8080
    '';
  };
}
