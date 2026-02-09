{ pkgs, ... }:
{
  systemd.services.tailscale-serve = {
    description = "Tailscale Serve configuration";
    after = [ "tailscaled.service" ];
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
      tailscale serve reset || true
      tailscale serve --bg --https 3000 3000
      tailscale serve --bg --https 3001 3001
      tailscale serve --bg --https 8123 8123
    '';
  };
}
