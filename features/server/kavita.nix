{ config, lib, ... }:

{
  networking.firewall.allowedTCPPorts = [ 5000 ];

  systemd.tmpfiles.rules = [
    "d /storage/shared/manga 0755 ${config.my.user.name} users - -"
    "d /storage/shared/books 0755 ${config.my.user.name} users - -"
  ];

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
