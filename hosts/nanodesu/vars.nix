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
  # Note: Run 'niri msg outputs' on the actual hardware to verify the correct output name
  # Typical laptop internal displays are named: eDP-1, eDP-2, or similar
  monitors = {
    primary = {
      name = "eDP-1"; # Internal laptop display (verify with niri msg outputs)
      width = 2160; # Native resolution width
      height = 1350; # Native resolution height (16:10 aspect ratio)
      refresh = 60.0; # Standard 60Hz for this model
      scale = 1.0; # No scaling as requested
      position = { x = 0; y = 0; };
      vrr = true; # Variable refresh rate enabled
    };
    # Add external monitors here when needed:
    # external = {
    #   name = "HDMI-A-1";
    #   width = 1920;
    #   height = 1080;
    #   refresh = 60.0;
    #   scale = 1.0;
    #   position = { x = 2160; y = 0; };  # To the right of laptop display
    #   vrr = false;
    # };
  };

  # Wallpaper (absolute path, not relative to config location)
  wallpaperPath = "/home/yawarakatai/.config/nix-config/home/nanodesu/wallpapers/bg.png";

  # Storage
  mainDisk = "/dev/nvme0n1"; # 512GB NVMe SSD

  # Performance specs
  # ThinkPad X1 Nano Gen 2: Intel 12th Gen (typically 4-10 cores depending on model)
  # Using 8 threads as typical for Core i5/i7 variants
  cpuCores = 8; # Intel 12th Gen (4 P-cores + efficiency cores = ~8 threads)
  ramGB = 16; # 16GB LPDDR5

  # Git configuration
  gitName = "yawarakatai";
  gitEmail = "186454332+yawarakatai@users.noreply.github.com";
}
