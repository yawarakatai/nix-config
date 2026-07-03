{ config, ... }:

{
  system.activationScripts.kavita-dirs = ''
    mkdir -p /storage/shared/manga /storage/shared/books
    chown ${config.my.user.name}:users /storage/shared/manga /storage/shared/books 2>/dev/null || true
  '';

  systemd.services.kavita.serviceConfig = {
    ReadWritePaths = [
      "/storage/shared/manga"
      "/storage/shared/books"
    ];
  };

  age.secrets.kavita-token = {
    rekeyFile = ../../secrets/kavita-token.age;
    owner = "kavita";
  };

  services.kavita = {
    enable = true;
    tokenKeyFile = config.age.secrets.kavita-token.path;
  };
}
