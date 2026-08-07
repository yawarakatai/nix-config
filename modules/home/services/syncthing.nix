{ lib, osConfig, ... }:
let
  deviceList = {
    "desuwa".id = "HAAEPVY-MDYSH7U-EHXSHJS-WGOFZJX-KX5ZQRJ-YEJIIKS-VRRYUNY-45HJ3A4";
    "nanodesu".id = "VBOMNKG-KY6FXZG-4GFCEDK-L5ESYEZ-PJYOOL2-5XGA6LH-2HRZYUK-S2L3OA5";
    "kamo".id = "CDQHJIJ-4HYQFYV-VFEYHZT-RF2Q3NO-DTAN5R5-CPVSTXR-WPML3UC-S24LZQ6";
    "phone".id = "O4JZAB6-TOGP5LH-B7H35Q7-PRCZXCI-RUUTPXM-U62XETT-AMGMF6E-Z2PN4QD";
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
