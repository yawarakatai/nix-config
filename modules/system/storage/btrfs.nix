# Btrfs optimization and SSD maintenance
{ config, vars, ... }:

{
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };

  services.fstrim = {
    enable = true;
    interval = "weekly";
  };
}
