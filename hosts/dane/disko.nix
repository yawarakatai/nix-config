{ ... }:

let
  btrfs-subvols = import ../../lib/disko-common.nix { };
in
{
  disko.devices = {
    disk = {
      # 256GB SK hynix BC711 — system drive
      nvme-system = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-BC711_NVMe_SK_hynix_256GB____CDA3N81581070463W";
        content = {
          type = "gpt";
          partitions = {
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = btrfs-subvols;
              };
            };
          };
        };
      };

      # 1TB WD BLACK SN770 — data / backup
      nvme-data = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-WD_BLACK_SN770_1TB_22134E800783";
        content = {
          type = "gpt";
          partitions = {
            data = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "@data" = {
                    mountpoint = "/data";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
