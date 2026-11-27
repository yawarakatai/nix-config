{ pkgs, ... }:

{
  i18n.inputMethod.fcitx5.addons = [ (pkgs.callPackage ./package.nix { }) ];
}
