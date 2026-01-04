{
  # Basic information
  username = "yawarakatai";
  hostname = "nanodesu";
  system = "x86_64-linux";

  # Locale and timezone
  locale = "en_US.UTF-8";
  keyboardLayout = "us";
  timezone = "Asia/Tokyo";

  # Display configuration
  # ThinkPad X1 Nano Gen 2 - 13" 2160x1350 (16:10) display
  monitors = {
    external = {
      name = "DP-1";
      width = 3840;
      height = 2160;
      refresh = 59.940;
      scale = 1.0;
      position = {
        x = 0;
        y = 0;
      };
      vrr = true;
    };

    primary = {
      name = "eDP-1"; # Internal laptop display
      width = 2160; # Native resolution width
      height = 1350; # Native resolution height (16:10 aspect ratio)
      refresh = 59.744; # Standard 60Hz for this model
      scale = 1.0; # No scaling as requested
      position = {
        x = 0;
        y = 2160;
      };
      vrr = false;
      focus-at-startup = true;
    };
  };

  # Storage
  mainDisk = "/dev/nvme0n1"; # 512GB NVMe SSD

  # Performance specs
  ramGB = 16; # 16GB LPDDR5
}
