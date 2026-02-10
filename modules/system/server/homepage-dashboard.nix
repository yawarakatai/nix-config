{ lib, ... }:

{
  services.homepage-dashboard = {
    enable = true;
    listenPort = 8082;

    settings = {
      title = "daze";
      favicon = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/raspberry-pi.png";
      theme = "dark";
      color = "stone";
      headerStyle = "clean";
      hideVersion = true;
      layout = {
        Services = {
          style = "row";
          columns = 2;
        };
        Infrastructure = {
          style = "row";
          columns = 3;
        };
      };
    };

    services = [
      {
        Services = [
          {
            "Uptime Kuma" = {
              href = "https://daze.ewe-major.ts.net:3001";
              icon = "uptime-kuma";
              description = "Service monitoring";
              widget = {
                type = "uptimekuma";
                url = "http://127.0.0.1:3001";
                slug = "default";
              };
            };
          }
          {
            "Home Assistant" = {
              href = "https://daze.ewe-major.ts.net:8124";
              icon = "home-assistant";
              description = "Home automation";
              widget = {
                type = "homeassistant";
                url = "http://127.0.0.1:8123";
                key = "{{HOMEPAGE_VAR_HA_TOKEN}}";
              };
            };
          }
        ];
      }
      {
        Infrastructure = [
          {
            "desuwa" = {
              icon = "mdi-desktop-tower";
              description = "Desktop (RTX 3080)";
            };
          }
          {
            "nanodesu" = {
              icon = "mdi-laptop";
              description = "Laptop";
            };
          }
          {
            "daze" = {
              icon = "mdi-raspberry-pi";
              description = "RPi4 Server";
            };
          }
        ];
      }
    ];

    widgets = [
      {
        datetime = {
          text_size = "xl";
          format = {
            dateStyle = "long";
            timeStyle = "short";
            hour12 = false;
          };
        };
      }
      {
        resources = {
          cpu = true;
          memory = true;
          disk = "/";
          label = "daze";
        };
      }
    ];
  };

  # Allow access from any host (Tailscale network)
  systemd.services.homepage-dashboard.environment = {
    "HOMEPAGE_ALLOWED_HOSTS" = lib.mkForce "*";
  };

  systemd.services.homepage-dashboard.serviceConfig.EnvironmentFile =
    "/var/lib/homepage-dashboard/env";
}
