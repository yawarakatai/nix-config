{ ... }:

{
  services.vaultwarden = {
    enable = true;
    environmentFile = "/data/vaultwarden/.env";
  };
}
