{ lib, vars, ... }:
let
  deviceList =
    {
      "desuwa" = { id = "ZR7INJC-T33D5ZE-SU6AAXE-ZNQ47VD-IWMU5MG-HHXU5N3-ITJKIOV-WRAYBAD"; };
      "nanodesu" = { id = "IWWSRPT-PXMX62T-UYRIGNA-F3RQNFD-ZQKSOMP-2GVEK2K-7VLVGO3-QL434AK"; };
      "phone" = { id = "Y34UUSW-2VJSWWW-U7HDZYV-W62BLJB-LMJHF66-B27X2A7-LFZS27Q-TTU5ZQB"; };
    };

  otherDevices = lib.filterAttrs (name: _: name != vars.hostname) deviceList;

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
