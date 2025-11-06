{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      niri-unstable = prev.niri-unstable.overrideAttrs (oldAttrs: {
        doCheck = false;
        checkPhase = ":";
      });
    })
  ];
}
