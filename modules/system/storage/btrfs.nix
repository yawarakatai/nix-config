# Btrfs optimization and SSD maintenance
{ ... }:

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
