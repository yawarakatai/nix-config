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
              href = "http://daze:3001";
              icon = "uptime-kuma";
              description = "Service monitoring";
            };
          }
          {
            "Home Assistant" = {
              href = "http:daze:8123";
              icon = "home-assistant";
              description = "Home automation";
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
}
