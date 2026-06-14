{ config, lib, ... }:

{
  networking.firewall.allowedTCPPorts = [ 4533 ];

  systemd.tmpfiles.rules = [
    "d /storage/shared/music 0755 ${config.my.user.name} users - -"
    "d /storage/shared/voice 0755 ${config.my.user.name} users - -"
    "d /data/navidrome 0755 navidrome navidrome - -"
  ];

  services.navidrome = {
    enable = true;
    settings = {
      Address = "0.0.0.0";
      Port = 4533;
      MusicFolder = "/storage/shared/music:/storage/shared/voice";
      DataFolder = "/data/navidrome";
    };
  };

  systemd.services.tailscale-serve.script = lib.mkAfter ''
    tailscale serve --bg --set-path /navidrome 4533
  '';
}
