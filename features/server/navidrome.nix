{ config, lib, ... }:

{
  networking.firewall.allowedTCPPorts = [ 4533 ];

  system.activationScripts.navidrome-dirs = ''
    mkdir -p /storage/shared/music /storage/shared/voice /data/navidrome
    chown ${config.my.user.name}:users /storage/shared/music /storage/shared/voice /storage/shared 2>/dev/null || true
    chown navidrome:navidrome /data/navidrome 2>/dev/null || true
  '';

  systemd.services.navidrome.serviceConfig = {
    ReadWritePaths = [ "/storage/shared" ];
  };

  services.navidrome = {
    enable = true;
    settings = {
      Address = "0.0.0.0";
      Port = 4533;
      MusicFolder = "/storage/shared";
      DataFolder = "/data/navidrome";
    };
  };

  systemd.services.tailscale-serve.script = lib.mkAfter ''
    tailscale serve --bg --set-path /navidrome 4533
  '';
}
