{ lib, osConfig, ... }:
let
  deviceList = {
    "desuwa".id = "6GXNO3M-P64TITJ-R5WU3VY-PECSWQC-RZGMW3T-L7DSBBO-JDN6UWL-EODKSAQ";
    "nanodesu".id = "M5QX6CG-YDXBBR3-UJEZ6X6-2BM2NX7-LLZY2M4-CNYAWQI-XYRYNWP-3ENXYAQ";
    "kamo".id = "IPUYD4E-Q47AA63-3WDK3WR-KMUTYQL-KF6STNB-LLNZ4BN-6KUMZ23-GRPH2AC";
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
