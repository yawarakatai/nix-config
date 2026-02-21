{ pkgs, ... }:

{
  imports = [
    ./steam.nix
  ];

  # Launch option
  # gamescope -W 1920 -H 1080 -r 60 -S integer -- %command%
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  environment.systemPackages = with pkgs; [
    protonplus
    heroic
  ];
}
