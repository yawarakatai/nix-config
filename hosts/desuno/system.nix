{
  lib,
  ...
}:

{
  imports = [
    ../../modules/server/minecraft.nix
  ];

  users.mutableUsers = false;

  networking.firewall = {
    allowedTCPPorts = lib.mkForce [ 22 ];
    allowedUDPPorts = lib.mkForce [ ];
    interfaces.tailscale0.allowedTCPPorts = [ 25565 ];
  };
}
