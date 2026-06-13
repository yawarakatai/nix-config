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
}
