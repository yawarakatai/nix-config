# User configuration
#
{
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  homePrograms = config.home-manager.users.${username}.programs or { };
in
{
  programs.zsh = {
    enable = true;
    # Avoid duplicate initialization only when Home Manager owns it.
    enableGlobalCompInit = lib.mkIf (homePrograms.zsh.enable or false) false;
    promptInit = lib.mkIf (homePrograms.starship.enable or false) "";
  };

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
