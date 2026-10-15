{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mangohud
  ];

  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraEnv.MANGOHUD = "1";
    };
    gamescopeSession.enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];

    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    dedicatedServer.openFirewall = false;
  };
}
