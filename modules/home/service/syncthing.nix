{ lib, osConfig, ... }:
let
  deviceList = {
    "desuwa" = {
      id = "ZR7INJC-T33D5ZE-SU6AAXE-ZNQ47VD-IWMU5MG-HHXU5N3-ITJKIOV-WRAYBAD";
    };
    "desuno" = {
      id = "A56MT4R-TES67G7-74QVYQC-7JVWJIP-H7FQAC5-XXNNRLY-VBGVXLO-S65DDAW";
    };
    "nanodesu" = {
      id = "IWWSRPT-PXMX62T-UYRIGNA-F3RQNFD-ZQKSOMP-2GVEK2K-7VLVGO3-QL434AK";
    };
    "kamo" = {
      id = "ZKPDVT5-4WEGR7G-2FP4PA7-FJNIWAE-5DMOHJ2-UGFBYZ6-LT6TJ4D-TDP3NAH";
    };
  };

  otherDevices = lib.filterAttrs (name: _: name != osConfig.my.user.name) deviceList;
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
        "docs" = {
          label = "docs";
          path = "/home/yawarakatai/docs";
          devices = peerNames;
          # ignorePerms = false;
        };
      };
    };
  };
}
