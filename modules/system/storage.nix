{ config, vars, ... }:

{
  # Btrfs optimization and maintenance
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };
  
  # fstrim for SSD optimization
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };
  
  # File system configuration is in hardware-configuration.nix
  # But we can set default mount options here if needed
  
  # Recommended Btrfs mount options (applied in hardware-configuration.nix):
  # - compress=zstd: Enable compression
  # - noatime: Don't update access time (performance)
  # - space_cache=v2: Use space cache v2 for better performance
  # - discard=async: Enable async discard for SSD
  
  # Subvolume structure:
  # @ -> /
  # @home -> /home
  # @nix -> /nix
  # @log -> /var/log
  # @cache -> /var/cache (optional, excluded from snapshots)
  # @tmp -> /tmp (optional, excluded from snapshots)
}
