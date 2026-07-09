{
  lib,
  username,
  ...
}:

{
  networking.hostName = lib.mkForce "dane";

  imports = [
    ../../modules/server/homepage-dashboard.nix
    ../../modules/server/gatus.nix
    ../../modules/server/caddy.nix
    ../../modules/server/vaultwarden.nix
    ../../modules/server/filebrowser.nix
    ../../modules/server/borg.nix
    ../../modules/server/navidrome.nix
    ../../modules/server/kavita.nix
    ../../modules/server/forgejo.nix
  ];

  security.sudo.extraRules = [
    {
      users = [ username ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  powerManagement.cpuFreqGovernor = "schedutil";

  services = {
    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="auto"
    '';

    caddy.virtualHosts = {
      "vault.yawarakatai.com".extraConfig = ''
        reverse_proxy localhost:8222
      '';

      "git.yawarakatai.com".extraConfig = ''
        reverse_proxy localhost:3000
      '';

      "file.yawarakatai.com".extraConfig = ''
        reverse_proxy localhost:8080
      '';

      "navidrome.yawarakatai.com".extraConfig = ''
        reverse_proxy localhost:4533
      '';

      "kavita.yawarakatai.com".extraConfig = ''
        reverse_proxy localhost:5000
      '';
    };
  };
}
