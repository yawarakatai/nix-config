{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking.firewall.allowedTCPPorts = [ 3000 ];

  systemd.tmpfiles.rules = [
    "d /data/forgejo 0750 git git - -"
  ];

  services.forgejo = {
    enable = true;
    settings = {
      server = {
        HTTP_ADDR = "0.0.0.0";
        HTTP_PORT = 3000;
        ROOT_URL = "https://dane.ewe-major.ts.net/git";
      };
    };
  };

  systemd.services.tailscale-serve.script = lib.mkAfter ''
    tailscale serve --bg --set-path /git 3000
  '';
}
