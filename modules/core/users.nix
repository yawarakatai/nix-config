# User configuration
#
{
  config,
  lib,
  pkgs,
  username,
  ...
}:

{
  programs.zsh.enable = true;

  users = {
    mutableUsers = false;
    users.${username} = {
      isNormalUser = true;
      description = username;
      shell = pkgs.zsh;
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
        "audio"
        "plugdev"
        "input"
      ]
      ++ lib.optional config.virtualisation.docker.enable "docker";
      hashedPasswordFile = config.age.secrets.user-password.path;
    };
    users.root.hashedPassword = "!"; # Disable root login
  };

  # Define the user password secret
  age.secrets.user-password.rekeyFile = ../../secrets/user-password.age;
}
