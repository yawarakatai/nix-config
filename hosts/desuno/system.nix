{
  lib,
  ...
}:

{
  imports = [
    ../../modules/server/minecraft.nix
    ../../modules/server/playit.nix
  ];

  users.mutableUsers = false;

  # Keep network routing outside this host until the topology is decided.
  networking.firewall = {
    allowedTCPPorts = lib.mkForce [
      22
      25565
    ];
    allowedUDPPorts = lib.mkForce [ ];
  };
}
