{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking.firewall.allowedTCPPorts = [ 5000 ];

  systemd.tmpfiles.rules = [
    "d /storage/shared 0755 ${config.my.user.name} users - -"
    "d /storage/shared/manga 0755 ${config.my.user.name} users - -"
    "d /storage/shared/books 0755 ${config.my.user.name} users - -"
  ];

  systemd.services.kavita.serviceConfig = {
    ExecStartPre = [
      "+${pkgs.coreutils}/bin/mkdir -p /storage/shared/manga /storage/shared/books"
      "+${pkgs.coreutils}/bin/chown ${config.my.user.name}:users /storage/shared/manga /storage/shared/books"
    ];
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

  systemd.services.tailscale-serve.script = lib.mkAfter ''
    tailscale serve --bg --set-path /kavita 5000
  '';
}
