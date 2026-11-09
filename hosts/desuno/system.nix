{
  lib,
  ...
}:

{
  users.mutableUsers = false;

  networking.firewall = {
    allowedTCPPorts = lib.mkForce [ 22 ];
    allowedUDPPorts = lib.mkForce [ ];
  };
}
