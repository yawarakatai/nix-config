_:

{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-BC711_NVMe_SK_hynix_256GB____CDA3N81581070463W";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          priority = 1;
          name = "ESP";
          start = "1M";
          end = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [
              "fmask=0077"
              "dmask=0077"
            ];
          };
        };
        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
            mountOptions = [ "noatime" ];
          };
        };
      };
    };
  };

  disko.devices.disk.storage = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-WD_BLACK_SN770_1TB_22134E800783";
    content = {
      type = "gpt";
      partitions.storage = {
        size = "100%";
        content = {
          type = "filesystem";
          format = "ext4";
          mountpoint = "/storage";
          mountOptions = [ "noatime" ];
        };
      };
    };
  };
}
