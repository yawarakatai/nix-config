# Btrfs optimization and SSD maintenance
_:

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
