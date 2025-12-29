# User configuration
{ lib, config, pkgs, vars, ... }:

{
  users = {
    mutableUsers = false;
    users.${vars.username} = {
      isNormalUser = true;
      description = vars.username;
      extraGroups = [ "networkmanager" "wheel" "video" "audio" "plugdev" ] ++ lib.optional config.virtualisation.docker.enable "docker";
      shell = pkgs.nushell;
    };
    users.root.hashedPassword = "!"; # Disable root login
  };
}
