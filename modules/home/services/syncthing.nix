{ lib, osConfig, ... }:
let
  deviceList = {
    "desuwa".id = "HAAEPVY-MDYSH7U-EHXSHJS-WGOFZJX-KX5ZQRJ-YEJIIKS-VRRYUNY-45HJ3A4";
    "nanodesu".id = "VBOMNKG-KY6FXZG-4GFCEDK-L5ESYEZ-PJYOOL2-5XGA6LH-2HRZYUK-S2L3OA5";
    "kamo".id = "DJTWXMI-XYOIWTJ-XEFCINQ-3NJ6H6G-PADQAHJ-5NWXGA6-RIL3IQD-IQLGMA5";
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
