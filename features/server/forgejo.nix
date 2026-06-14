{
  config,
  pkgs,
  ...
}:

{
  systemd.tmpfiles.rules = [
    "d /data/forgejo 0750 git git - -"
  ];

  services.forgejo = {
    enable = true;
    settings = {
      server = {
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3000;
        ROOT_URL = "https://git.yawarakatai.com";
      };
    };
  };
}
