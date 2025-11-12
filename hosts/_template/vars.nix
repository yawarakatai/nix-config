{
  # Basic information
  username = "your-username";
  hostname = "your-hostname";
  system = "x86_64-linux"; # or "aarch64-linux" for ARM

  # Locale and timezone
  locale = "en_US.UTF-8";
  keyboardLayout = "us";
  timezone = "America/New_York"; # Change to your timezone

  # Display configuration
  # Find monitor names with: niri msg outputs
  monitors = {
    primary = {
      name = "DP-1"; # Monitor output name
      width = 1920; # Resolution width
      height = 1080; # Resolution height
      refresh = 60.0; # Refresh rate in Hz
      scale = 1.0; # HiDPI scale (1.0, 1.5, 2.0, etc.)
      position = { x = 0; y = 0; }; # Position in multi-monitor setup
      vrr = false; # Variable refresh rate (FreeSync/G-Sync)
    };
    # Add additional monitors here:
    # secondary = {
    #   name = "HDMI-A-1";
    #   width = 1920;
    #   height = 1080;
    #   refresh = 60.0;
    #   scale = 1.0;
    #   position = { x = 1920; y = 0; };  # To the right of primary
    #   vrr = false;
    # };
  };

  # Wallpaper (relative path - Nix will copy to store)
  # Replace HOSTNAME with your actual hostname directory name
  wallpaperPath = ../../wallpapers/bg.png;

  # Storage
  mainDisk = "/dev/sda"; # Your main disk (find with: lsblk)

  # Performance specs
  ramGB = 16; # RAM in GB

  # Git configuration
  gitName = "Your Name";
  gitEmail = "your-email@example.com";
}
