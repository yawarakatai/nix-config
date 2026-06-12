{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 13378 ];

  systemd.tmpfiles.rules = [
    "d /data/audiobookshelf 0750 audiobookshelf audiobookshelf - -"
  ];

  services.audiobookshelf = {
    enable = true;
    host = "0.0.0.0";
    port = 13378;
  };

  systemd.services.tailscale-serve-audiobookshelf = {
    wantedBy = [ "multi-user.target" ];
    after = [ "tailscaled.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      ${pkgs.tailscale}/bin/tailscale serve --bg --set-path /audiobookshelf 13378
    '';
  };
}
