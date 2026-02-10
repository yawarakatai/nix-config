{ ... }:

let
  haConfig = ''
    homeassistant:
      name: Home
      unit_system: metric
      time_zone: Asia/Tokyo

    default_config:

    http:
      use_x_forwarded_for: true
      trusted_proxies:
        - 127.0.0.1
        - ::1
  '';
in
{
  virtualisation.oci-containers.backend = "docker";

  virtualisation.oci-containers.containers.homeassistant = {
    image = "ghcr.io/home-assistant/home-assistant:stable";
    volumes = [
      "/var/lib/homeassistant:/config"
      "/run/dbus:/run/dbus:ro"
    ];
    extraOptions = [
      "--network=host"
      "--cap-add=NET_ADMIN"
      "--cap-add=NET_RAW"
    ];
    environment = {
      TZ = "Asia/Tokyo";
    };
  };

  systemd.services.homeassistant-config = {
    description = "Setup Home Assistant configuration";
    before = [ "docker-homeassistant.service" ];
    wantedBy = [ "docker-homeassistant.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      mkdir -p /var/lib/homeassistant

      # create configuration.yaml at the first time
      if [ ! -f /var/lib/homeassistant/configuration.yaml ]; then
        cat > /var/lib/homeassistant/configuration.yaml << 'HACONFIG'
      ${haConfig}
      HACONFIG
      fi
    '';
  };
}
