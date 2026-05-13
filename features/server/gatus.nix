{ ... }:

{
  services.gatus = {
    enable = true;

    settings = {
      web = {
        address = "0.0.0.0";
        port = 3001;
      };

      endpoints = [
        {
          name = "Home Assistant";
          group = "Internal";
          url = "http://127.0.0.1:8123";
          interval = "60s";
          conditions = [ "[STATUS] == 200" ];
        }
        {
          name = "Homepage";
          group = "Internal";
          url = "http://127.0.0.1:8082";
          interval = "60s";
          conditions = [ "[STATUS] == 200" ];
        }
        {
          name = "Google";
          group = "External";
          url = "https://www.google.com";
          interval = "300s";
          conditions = [ "[STATUS] == 200" ];
        }
      ];
    };
  };
}
