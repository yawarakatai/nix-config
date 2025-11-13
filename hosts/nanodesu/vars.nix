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
    external = {
      name = "DP-3";
      width = 3840;
      height = 2160;
      refresh = 59.940;
      scale = 1.0;
      position = { x = 0; y = 0; };
      vrr = true;
      focus-at-startup = true;
    };

    primary = {
      name = "eDP-1"; # Internal laptop display (verify with niri msg outputs)
      width = 2160; # Native resolution width
      height = 1350; # Native resolution height (16:10 aspect ratio)
      refresh = 59.744; # Standard 60Hz for this model
      scale = 1.0; # No scaling as requested
      position = { x = 0; y = 2160; };
      vrr = false;
      focus-at-startup = true;
    };
  };

  # Wallpaper (do not use relative path - Nix will copy to store)
  wallpaperPath = "/home/yawarakatai/.config/nix-config/wallpapers/bg.png";

  # Storage
  mainDisk = "/dev/nvme0n1"; # 512GB NVMe SSD

  # Performance specs
  ramGB = 16; # 16GB LPDDR5

  # Git configuration
  gitName = "yawarakatai";
  gitEmail = "186454332+yawarakatai@users.noreply.github.com";
}
