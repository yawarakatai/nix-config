{ lib, osConfig, ... }:
let
  deviceList = {
    "desuwa".id = "6GXNO3M-P64TITJ-R5WU3VY-PECSWQC-RZGMW3T-L7DSBBO-JDN6UWL-EODKSAQ";
    "nanodesu".id = "VBOMNKG-KY6FXZG-4GFCEDK-L5ESYEZ-PJYOOL2-5XGA6LH-2HRZYUK-S2L3OA5";
    "kamo".id = "L3II5PP-L5JOB7I-JTKNZPB-GI7QVWQ-BDE3SKZ-4XNNMKG-ATOAOZP-465HRA7";
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
