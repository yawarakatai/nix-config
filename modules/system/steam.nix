{ pkgs, ... }:

{
  # Enable Steam with proper FHS environment
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Steam Remote Play
    dedicatedServer.openFirewall = true; # Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true;

    gamescopeSession.enable = true; # Gamescope compositor for better Wayland support

    # Additional compatibility packages
    extraCompatPackages = with pkgs; [ proton-ge-bin ];

    # Package overrides for additional library compatibility
    package = pkgs.steam.override {
      extraEnv = {
        # Skip X11 update UI that fails on Wayland-only compositors
        STEAM_UPDATE_UI = "0";
      };
      extraLibraries = pkgs: with pkgs; [
        # Additional libraries for X11 compatibility
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver

        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
      ];
    };
  };
}
