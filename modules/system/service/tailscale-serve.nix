{ pkgs, ... }:
{
  systemd.services.tailscale-serve = {
    description = "Tailscale Serve configuration";
    after = [
      "tailscaled.service"
      "homepage-dashboard.service"
      "docker-homeassistant.service"
      "uptime-kuma.service"
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

      tailscale serve reset 2>/dev/null || true

      # Homepage
      tailscale serve --bg --https=3000 http://127.0.0.1:8082

      # Uptime Kuma
      tailscale serve --bg --https=3001 http://127.0.0.1:3001

      # Home Assistant
      tailscale serve --bg --https=8123 http://127.0.0.1:8123
    '';
  };
}
