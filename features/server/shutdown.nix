{ pkgs, ... }:

{
  systemd.services.shutdown-endpoint = {
    description = "Shutdown via HTTP";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.writeShellScript "shutdown-server" ''
                echo 'HTTP/1.1 200 OK
        '
                echo 'Shutting down...'
                ${pkgs.systemd}/bin/systemctl poweroff
      ''}";
    };
  };

  systemd.sockets.shutdown-endpoint = {
    wantedBy = [ "sockets.target" ];
    socketConfig = {
      ListenStream = 9999;
    };
  };
}
