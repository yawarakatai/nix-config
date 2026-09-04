{
  config,
  inputs,
  lib,
  ...
}:

{
  imports = [
    inputs.playit-nixos-module.nixosModules.default
  ];

  age.secrets.playit-secret.rekeyFile = ../../secrets/playit-secret.age;

  systemd.services.NetworkManager-wait-online.enable = lib.mkForce true;

  systemd.services.playit = {
    wants = [ "systemd-resolved.service" ];
    after = [ "systemd-resolved.service" ];
    startLimitIntervalSec = 300;
    startLimitBurst = 30;
    serviceConfig.RestartSec = "15s";
  };

  services.playit = {
    enable = true;
    secretPath = config.age.secrets.playit-secret.path;
  };
}
