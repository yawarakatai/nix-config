{ config, pkgs, ... }:

{
  users.users.studio = {
    isNormalUser = true;
    description = "studio";
    shell = pkgs.zsh;
    # No wheel, docker, or input: this account must not reach the personal one.
    extraGroups = [
      "video"
      "audio"
    ];
    hashedPasswordFile = config.age.secrets.user-password.path;
  };

  home-manager.users.studio = import ../profiles/home/recording.nix;
}
