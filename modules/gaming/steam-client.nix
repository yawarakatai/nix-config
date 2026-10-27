{
  programs.steam = {
    enable = true;
    # Steam Input's desktop layout needs uinput rather than X11 events on Niri.
    extest.enable = true;

    # This machine primarily receives Remote Play streams, rather than hosting.
    remotePlay.openFirewall = false;
    localNetworkGameTransfers.openFirewall = false;
    dedicatedServer.openFirewall = false;
  };
}
