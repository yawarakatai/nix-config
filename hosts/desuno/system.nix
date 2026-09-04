{
  lib,
  pkgs,
  username,
  ...
}:

{
  imports = [
    ../../modules/server/minecraft.nix
  ];

  programs.zsh.enable = true;

  users = {
    mutableUsers = false;
    users.${username} = {
      isNormalUser = true;
      description = username;
      shell = pkgs.zsh;
      extraGroups = [ "wheel" ];
      hashedPassword = "!";
    };
    users.root.hashedPassword = "!";
  };

  # Keep network routing outside this host until the topology is decided.
  networking.firewall = {
    allowedTCPPorts = lib.mkForce [
      22
      25565
    ];
    allowedUDPPorts = lib.mkForce [ ];
  };
}
