# User configuration
#
{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.zsh.enable = true;

  users = {
    mutableUsers = false;
    users.${config.my.user.name} = {
      isNormalUser = true;
      description = config.my.user.name;
      shell = pkgs.zsh;
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
        "audio"
        "plugdev"
      ]
      ++ lib.optional config.virtualisation.docker.enable "docker";
      hashedPasswordFile = config.age.secrets.user-password.path;
    };
    users.root.hashedPassword = "!"; # Disable root login
  };

  # Define the user password secret
  age.secrets.user-password.rekeyFile = ../../../secrets/user-password.age;
}
