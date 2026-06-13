{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 8222 ];

  age.secrets.vaultwarden-admin-token = {
    rekeyFile = ../../secrets/vaultwarden-admin-token.age;
    owner = "vaultwarden";
  };

  services.vaultwarden = {
    enable = true;
    environmentFile = config.age.secrets.vaultwarden-admin-token.path;
    config = {
      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = 8222;
      DOMAIN = "https://dane.ewe-major.ts.net";
    };
  };
}
