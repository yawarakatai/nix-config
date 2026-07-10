{ inputs, ... }:

{
  imports = [
    inputs.ura.homeManagerModules.default
  ];

  services.ura = {
    enable = true;

    bind = "0.0.0.0:8765";

    logLevel = "ura=info";
  };
}
