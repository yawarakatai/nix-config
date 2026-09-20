{ pkgs, ... }:

{
  imports = [
    ./steam.nix
  ];

  programs = {
    gamemode.enable = true;

    gamescope = {
      enable = true;
      capSysNice = true;
    };
  };

  environment.systemPackages = with pkgs; [
    heroic
    mangohud
    protonplus
    protontricks
  ];
}
