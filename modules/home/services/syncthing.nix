{ lib, osConfig, ... }:
let
  deviceList = {
    "desuwa".id = "HAAEPVY-MDYSH7U-EHXSHJS-WGOFZJX-KX5ZQRJ-YEJIIKS-VRRYUNY-45HJ3A4";
    "nanodesu".id = "VBOMNKG-KY6FXZG-4GFCEDK-L5ESYEZ-PJYOOL2-5XGA6LH-2HRZYUK-S2L3OA5";
    "kamo".id = "CDQHJIJ-4HYQFYV-VFEYHZT-RF2Q3NO-DTAN5R5-CPVSTXR-WPML3UC-S24LZQ6";
    "da".id = "N2T2MK5-MC7BELM-JSDRIVP-Z4XIVYB-RH7ZAJR-7DKHH7C-CP333B5-NKDXXAE";
  };

  otherDevices = lib.filterAttrs (name: _: name != osConfig.networking.hostName) deviceList;
  peerNames = lib.attrNames otherDevices;

in
{
  services.syncthing = {
    enable = true;

    overrideDevices = true;
    overrideFolders = true;

    settings = {
      devices = deviceList;

      folders = {
        "sync" = {
          label = "sync";
          path = "/home/yawarakatai/sync";
          devices = peerNames;
          # ignorePerms = false;
        };
      };
    };
  };
}
