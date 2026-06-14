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

    virtualHosts."vault.yawarakatai.com" = {
      serverAliases = [ "*.yawarakatai.com" ];
      extraConfig = ''
        tls {
          dns cloudflare {env.CF_API_TOKEN}
        }

        @vault host vault.yawarakatai.com
        handle @vault {
          reverse_proxy localhost:8222
        }

        @git host git.yawarakatai.com
        handle @git {
          reverse_proxy localhost:3000
        }

        @file host file.yawarakatai.com
        handle @file {
          reverse_proxy localhost:8080
        }

        @navidrome host navidrome.yawarakatai.com
        handle @navidrome {
          reverse_proxy localhost:4533
        }

        @kavita host kavita.yawarakatai.com
        handle @kavita {
          reverse_proxy localhost:5000
        }
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
