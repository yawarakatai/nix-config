{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mangohud
    bs-manager
  ];

  programs = {
    gamemode.enable = true;

    gamescope = {
      enable = true;
      capSysNice = true;
    };

    steam = {
      enable = true;
      gamescopeSession.enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];

      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      dedicatedServer.openFirewall = false;
    };
  };
}
