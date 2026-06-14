{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking.firewall.allowedTCPPorts = [ 13378 ];

  systemd.tmpfiles.rules = [
    "d /storage/shared 0755 ${config.my.user.name} users - -"
  ];

  services.audiobookshelf = {
    enable = true;
    host = "0.0.0.0";
    port = 13378;
  };

  systemd.services.tailscale-serve.script = lib.mkAfter ''
    tailscale serve --bg --set-path /audiobookshelf 13378
  '';
}
