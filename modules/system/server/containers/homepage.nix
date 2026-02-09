{ lib, ... }:

let
  # Service definitions for the dashboard
  myServices = [
    {
      group = "Monitoring";
      items = [
        {
          name = "Uptime Kuma";
          href = "https://daze:3001";
          icon = "uptime-kuma.png";
          description = "Service monitoring";
          widget = {
            type = "uptimekuma";
            url = "http://localhost:3001";
            slug = "default";
          };
        }
      ];
    }
    {
      group = "Smart Home";
      items = [
        {
          name = "Home Assistant";
          href = "https://daze:8123";
          icon = "home-assistant.png";
          description = "Home automation";
          widget = {
            type = "homeassistant";
            url = "http://localhost:8123";
            # TODO: Set HA long-lived access token (manage with agenix)
            key = "";
          };
        }
      ];
    }
    {
      group = "Infrastructure";
      items = [
        {
          name = "desuwa";
          icon = "mdi-desktop-tower";
          description = "Desktop (RTX 3080)";
        }
        {
          name = "nanodesu";
          icon = "mdi-laptop";
          description = "Laptop";
        }
        {
          name = "daze";
          icon = "mdi-raspberry-pi";
          description = "RPi4 Server";
        }
      ];
    }
  ];
in
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
      layout = {
        Monitoring = {
          style = "row";
          columns = 2;
        };
        "Smart Home" = {
          style = "row";
          columns = 1;
        };
        Infrastructure = {
          style = "row";
          columns = 3;
        };
      };
    };

    services = myServices;

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

  systemd.services.homepage-dashboard.environment = {
    "HOMEPAGE_ALLOWED_HOSTS" = lib.mkForce "*";
  };
}
