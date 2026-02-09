{ lib, ... }:

let
  services = [
    {
      group = "Monitoring";
      items = [
        {
          name = "Uptime Kuma";
          href = "https://daze.tail-XXXXX.ts.net:3001";
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
          href = "https://daze.tail-XXXXX.ts.net:8123";
          icon = "home-assistant.png";
          description = "Home automation";
          widget = {
            type = "homeassistant";
            url = "http://localhost:8123";
            key = ""; # TODO: HA long-lived access token
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

  mkServiceGroup = group: {
    ${group.group} = map (
      item:
      lib.filterAttrs (_: v: v != null && v != "") {
        inherit (item) name description;
        href = item.href or null;
        icon = item.icon or null;
        widget = item.widget or null;
      }
    ) group.items;
  };

  servicesYaml = builtins.toJSON (map mkServiceGroup services);

  settingsYaml = builtins.toJSON {
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

  widgetsYaml = builtins.toJSON [
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

  configDir = "/etc/homepage";
in
{
  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers.homepage = {
    image = "ghcr.io/gethomepage/homepage:latest";
    ports = [ "3000:3000" ];
    volumes = [
      "${configDir}:/app/config:ro"
      "/var/run/docker.sock:/var/run/docker.sock:ro"
    ];
    environment = {
      PUID = "1000";
      PGID = "1000";
    };
  };

  environment.etc = {
    "homepage/services.yaml".text = servicesYaml;
    "homepage/settings.yaml".text = settingsYaml;
    "homepage/widgets.yaml".text = widgetsYaml;
    "homepage/bookmarks.yaml".text = builtins.toJSON [ ];
    "homepage/docker.yaml".text = builtins.toJSON { };
  };
}
