{ username, ... }:

{
  system.activationScripts.navidrome-dirs = ''
    mkdir -p /storage/shared/music /storage/shared/voice /data/navidrome
    chown ${username}:users /storage/shared/music /storage/shared/voice /storage/shared 2>/dev/null || true
    chown navidrome:navidrome /data/navidrome 2>/dev/null || true
    chmod -R a+rX /storage/shared/music /storage/shared/voice 2>/dev/null || true
  '';

  users.users.navidrome.extraGroups = [ "users" ];

  systemd.services.navidrome.serviceConfig = {
    ReadWritePaths = [ "/storage/shared" ];
  };

  services.navidrome = {
    enable = true;
    settings = {
      Address = "127.0.0.1";
      Port = 4533;
      MusicFolder = "/storage/shared";
      DataFolder = "/data/navidrome";
    };
  };
}
