# User configuration
{
  config,
  lib,
  pkgs,
  vars,
  ...
}:

{
  users = {
    mutableUsers = false;
    users.${vars.username} = {
      isNormalUser = true;
      description = vars.username;
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
        "audio"
        "plugdev"
      ]
      ++ lib.optional config.virtualisation.docker.enable "docker";
      shell = pkgs.nushell;
      hashedPasswordFile = config.age.secrets.user-password.path;
    };
    users.root.hashedPassword = "!"; # Disable root login
  };

  # Define the user password secret
  age.secrets.user-password.rekeyFile = ../../../secrets/user-password.age;
}
