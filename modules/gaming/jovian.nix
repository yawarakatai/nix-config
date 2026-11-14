{
  inputs,
  lib,
  username,
  ...
}:

{
  imports = [
    inputs.jovian.nixosModules.default
  ];

  # The vendor session prefers any external connector before the handheld panel.
  # Keep external displays available as a fallback, without changing Niri's layout.
  nixpkgs.overlays = lib.mkAfter [
    (_final: prev: {
      jovianPackages = prev.jovianPackages.overrideScope (
        _jfinal: jprev: {
          gamescope-session = jprev.gamescope-session.overrideAttrs (old: {
            postPatch = (old.postPatch or "") + ''
              substituteInPlace gamescope-session \
                --replace-fail "-O '*',eDP-1" "-O eDP-1,'*'"
            '';
          });
        }
      );
    })
  ];

  jovian = {
    steam = {
      enable = true;
      autoStart = true;
      user = username;
    };

    # Keep the existing host's storage, memory, and kernel tuning.
    steamos.useSteamOSConfig = false;
  };

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
