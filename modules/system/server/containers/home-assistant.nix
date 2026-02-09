{ ... }:

{
  virtualisation.oci-containers.backend = "docker";

  virtualisation.oci-containers.containers.homeassistant = {
    image = "ghcr.io/home-assistant/home-assistant:stable";
    volumes = [
      "/var/lib/homeassistant:/config"
      "/run/dbus:/run/dbus:ro"
    ];
    extraOptions = [
      "--privileged"
    ];
    ports = [ "8123:8123" ];
    environment = {
      TZ = "Asia/Tokyo";
    };
  };
}
