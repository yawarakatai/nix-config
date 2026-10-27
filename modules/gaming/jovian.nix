{
  inputs,
  lib,
  username,
  ...
}:

{
  imports = [
    inputs.jovian.nixosModules.default
    ./steam-client.nix
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
}
