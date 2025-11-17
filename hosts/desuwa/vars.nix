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
  monitors = {
    # Primary monitor
    primary = {
      name = "HDMI-A-1";
      width = 3840;
      height = 2160;
      refresh = 119.880;
      scale = 1.0;
      position = { x = 0; y = 0; };
      vrr = true; # Variable refresh rate
    };
    # Add additional monitors here as needed
    # secondary = { ... };
  };

  # Wallpaper (do not use relative path - Nix will copy to store)
  wallpaperPath = "/home/yawarakatai/.config/nix-config/wallpapers/bg.png";

  # Storage
  mainDisk = "/dev/nvme0n1";

  # Performance specs
  ramGB = 16;

  # Git configuration
  gitName = "yawarakatai";
  gitEmail = "186454332+yawarakatai@users.noreply.github.com";
}
