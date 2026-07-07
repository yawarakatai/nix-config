{
  config,
  ...
}:

{
  age.secrets.vaultwarden-admin-token = {
    rekeyFile = ../../secrets/vaultwarden-admin-token.age;
    owner = "vaultwarden";
  };

  services.vaultwarden = {
    enable = true;
    environmentFile = config.age.secrets.vaultwarden-admin-token.path;
    config = {
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      DOMAIN = "https://vault.yawarakatai.com";
    };
  };
}
