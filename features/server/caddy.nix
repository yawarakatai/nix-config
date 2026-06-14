{ config, pkgs, ... }:

{
  system.activationScripts.caddy-env = ''
    printf 'CF_API_TOKEN=%s' "$(cat ${config.age.secrets.cloudflare-token.path})" > /run/caddy-env
    chmod 600 /run/caddy-env
    chown caddy:caddy /run/caddy-env 2>/dev/null || true
  '';

  systemd.services.caddy.serviceConfig = {
    EnvironmentFile = "/run/caddy-env";
  };

  age.secrets.cloudflare-token = {
    rekeyFile = ../../secrets/cloudflare-api-token.age;
    owner = "caddy";
  };

  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
      hash = "sha256-8yZDrejNKsaUnUaTUFYbarWNmxafqp2z2rWo+XRsxV8=";
    };

    globalConfig = ''
      acme_dns cloudflare {env.CF_API_TOKEN}
    '';
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
