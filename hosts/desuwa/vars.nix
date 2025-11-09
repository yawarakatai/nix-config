{
  # Basic information
  username = "yawarakatai";
  hostname = "desuwa";
  system = "x86_64-linux";

  # Locale and timezone
  locale = "en_US.UTF-8";
  keyboardLayout = "us";
  timezone = "Asia/Tokyo";

  # Graphics hardware
  hasNvidia = true;         # NVIDIA RTX 3080
  hasAMD = false;           # No AMD GPU
  hasIntel = false;         # No Intel integrated graphics

  # Connectivity hardware
  hasWifi = false;          # Desktop - no WiFi adapter
  hasBluetooth = false;     # No Bluetooth adapter
  hasEthernet = true;       # Wired ethernet connection

  # Input devices
  hasLogitechMouse = true;  # Logitech mouse with custom button mapping
  hasCustomKeyboard = true; # Lofree Flow keyboard with Fn key fixes
  hasTouchpad = false;      # Desktop - no touchpad
  hasTouchscreen = false;   # No touchscreen

  # Biometric & Security
  hasYubikey = true;        # YubiKey for GPG/SSH
  hasFingerprintSensor = false; # No fingerprint reader
  hasTPM = false;           # No TPM chip

  # Other peripherals
  hasPrinter = false;       # No printer configured
  hasScanner = false;       # No scanner
  hasWebcam = false;        # No webcam

  # Display configuration
  hasHiDPI = true;
  monitors = [ "HDMI-A-2" ]; # 4K 144Hz monitor

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
