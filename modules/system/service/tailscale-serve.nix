{ pkgs, ... }:
{
  systemd.services.tailscale-serve = {
    description = "Tailscale Serve configuration";
    after = [
      "tailscaled.service"
      "docker-homepage.service"
      "docker-homeassistant.service"
      "docker-uptime-kuma.service"
    ];
    wants = [ "tailscaled.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    path = [
      pkgs.tailscale
      pkgs.jq
    ];

    script = ''
      # Wait for Tailscale to come online
      until tailscale status --json 2>/dev/null \
        | jq -e '.Self.Online' > /dev/null 2>&1; do
        sleep 2
      done

      tailscale serve reset || true

      # Homepage: expose at https:3000, proxy to container on 8082
      tailscale serve --bg --https 3000 https://localhost:8082

      # Uptime Kuma
      tailscale serve --bg --https 3001 https://localhost:3001

      # Home Assistant
      tailscale serve --bg --https 8123 https://localhost:8123
    '';
  };
}
