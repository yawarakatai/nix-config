{ pkgs, ... }:

{
  systemd.services.tailscale-serve = {
    description = "Tailscale Serve configuration";
    after = [
      "tailscaled.service"
      "forgejo.service"
      "filebrowser.service"
      "audiobookshelf.service"
      "vaultwarden.service"
      "homepage-dashboard.service"
      "docker-homeassistant.service"
      "gatus.service"
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
      until tailscale status --json 2>/dev/null \
        | jq -e '.Self.Online' > /dev/null 2>&1; do
        sleep 2
      done

      tailscale serve reset 2>/dev/null || true
    '';
  };
}
