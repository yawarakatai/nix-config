# Btrfs optimization and SSD maintenance
{ config, ... }:

{
  services.btrfs.autoScrub = {
    enable = config.fileSystems."/".fsType == "btrfs";
    interval = "monthly";
    fileSystems = [ "/" ];
  };

  services.fstrim = {
    enable = true;
    interval = "weekly";
  };
}
