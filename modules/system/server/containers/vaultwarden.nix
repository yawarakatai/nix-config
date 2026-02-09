{ ... }:
{
  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers.vaultwarden = {
    image = "vaultwarden/server:latest";
    ports = [ "8080:80" ];
    volumes = [ "/var/lib/vaultwarden:/data" ];
    environment.SIGNUPS_ALLOWED = "true";
  };
}
