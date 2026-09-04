{
  config,
  inputs,
  ...
}:

{
  imports = [
    inputs.playit-nixos-module.nixosModules.default
  ];

  age.secrets.playit-secret.rekeyFile = ../../secrets/playit-secret.age;

  services.playit = {
    enable = true;
    secretPath = config.age.secrets.playit-secret.path;
  };
}
