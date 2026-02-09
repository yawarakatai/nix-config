{ ... }:
{
  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers.uptime-kuma = {
    image = "louislam/uptime-kuma:1";
    ports = [ "3001:3001" ];
    volumes = [ "/var/lib/uptime-kuma:/app/data" ];
  };
}
