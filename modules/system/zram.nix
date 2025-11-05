{ config, vars, ... }:

{
  # zram configuration for swap
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;  # Use 50% of RAM for zram
    priority = 100;
  };
  
  # Disable zswap (don't use both zram and zswap)
  boot.kernelParams = [ "zswap.enabled=0" ];
  
  # No swap partitions
  swapDevices = [ ];
  
  # Kernel parameters for better memory management
  boot.kernel.sysctl = {
    # Swappiness (0-100, lower = less aggressive swapping)
    "vm.swappiness" = 10;
    
    # VFS cache pressure
    "vm.vfs_cache_pressure" = 50;
  };
}
