{
  # Basic information
  username = "yawarakatai";
  hostname = "desuwa";
  system = "x86_64-linux";

  # Locale and timezone
  locale = "en_US.UTF-8";
  keyboardLayout = "us";
  timezone = "Asia/Tokyo";

  # Display configuration
  monitors = [ "HDMI-A-1" ]; # 4K 144Hz monitor

  # Wallpaper (absolute path, not relative to config location)
  wallpaperPath = "/home/yawarakatai/.config/nix-config/home/wallpapers/bg.png";

  # Storage
  mainDisk = "/dev/nvme0n1";

  # Performance specs
  cpuCores = 16; # Ryzen 7 3700X (8 cores, 16 threads)
  ramGB = 16;

  # Git configuration
  gitName = "yawarakatai";
  gitEmail = "186454332+yawarakatai@users.noreply.github.com";
}
