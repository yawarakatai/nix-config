{
  # Basic information
  username = "your-username";
  hostname = "your-hostname";
  system = "x86_64-linux"; # or "aarch64-linux" for ARM

  # Locale and timezone
  locale = "en_US.UTF-8";
  keyboardLayout = "us";
  timezone = "America/New_York"; # Change to your timezone

  # Hardware characteristics
  hasNvidia = false;        # Set to true if you have an NVIDIA GPU
  hasBluetooth = false;     # Set to true to enable Bluetooth support

  # Optional hardware/peripherals (set to false if not needed)
  hasLogitechMouse = false;  # Enable logiops configuration for Logitech mice
  hasCustomKeyboard = false; # Enable custom keyboard fixes (e.g., Lofree Flow)
  hasYubikey = false;        # Enable Yubikey support

  # Display configuration
  hasHiDPI = false;
  monitors = [ "DP-1" ]; # List your monitor outputs (find with: niri msg outputs)

  # Wallpaper (absolute path, not relative to config location)
  wallpaperPath = "/home/your-username/.config/nix-config/home/wallpapers/bg.png";

  # Storage
  mainDisk = "/dev/sda"; # Your main disk (find with: lsblk)

  # Performance specs
  cpuCores = 8;  # Number of CPU threads
  ramGB = 16;    # RAM in GB

  # Git configuration
  gitName = "Your Name";
  gitEmail = "your-email@example.com";
}
