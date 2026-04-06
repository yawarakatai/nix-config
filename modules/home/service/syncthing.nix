{ lib, osConfig, ... }:
let
  deviceList = {
    "desuwa" = {
      id = "HAAEPVY-MDYSH7U-EHXSHJS-WGOFZJX-KX5ZQRJ-YEJIIKS-VRRYUNY-45HJ3A4";
    };
    "desuno" = {
      id = "A56MT4R-TES67G7-74QVYQC-7JVWJIP-H7FQAC5-XXNNRLY-VBGVXLO-S65DDAW";
    };
    "nanodesu" = {
      id = "VBOMNKG-KY6FXZG-4GFCEDK-L5ESYEZ-PJYOOL2-5XGA6LH-2HRZYUK-S2L3OA5 ";
    };
    "kamo" = {
      id = "ZKPDVT5-4WEGR7G-2FP4PA7-FJNIWAE-5DMOHJ2-UGFBYZ6-LT6TJ4D-TDP3NAH";
    };
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
