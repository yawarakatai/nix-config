_:

{
  # Only the replaceable system drive is managed by disko. The SN770 data
  # drive is mounted by its stable ID and is intentionally never formatted.
  disko.devices.disk.nvme-system = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-BC711_NVMe_SK_hynix_256GB____CDA3N81581070463W";
    content = {
      type = "gpt";
      partitions.root = {
        start = "32M";
        size = "100%";
        content = {
          type = "filesystem";
          format = "ext4";
          extraArgs = [
            "-L"
            "NIXOS_NVME"
          ];
          mountpoint = "/";
          mountOptions = [ "noatime" ];
        };
      };
    };
  };
}
