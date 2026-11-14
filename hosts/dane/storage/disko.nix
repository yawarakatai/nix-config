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

  # Dedicated to borg repositories, which checksum and encrypt their own data.
  disko.devices.disk.backup = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-WD_BLACK_SN770_1TB_22134E800783";
    content = {
      type = "gpt";
      partitions.backup = {
        size = "100%";
        content = {
          type = "filesystem";
          format = "ext4";
          # Root never writes here, so the default 5% reservation would only waste space.
          extraArgs = [
            "-L"
            "backup"
            "-m"
            "0"
          ];
          mountpoint = "/srv/backup";
          mountOptions = [
            "noatime"
            "nodev"
            "nosuid"
            "noexec"
            # A failed backup disk must not keep the router from booting.
            "nofail"
            "x-systemd.device-timeout=10s"
          ];
        };
      };
    };
  };
}
