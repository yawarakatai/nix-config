{
  # Basic information
  username = "your-username";
  hostname = "your-hostname";
  system = "x86_64-linux"; # or "aarch64-linux" for ARM

  # Locale and timezone
  locale = "en_US.UTF-8";
  keyboardLayout = "us";
  timezone = "America/New_York"; # Change to your timezone

  # Graphics hardware
  hasNvidia = false;        # NVIDIA GPU (proprietary drivers)
  hasAMD = false;           # AMD GPU (open source drivers, usually auto-detected)
  hasIntel = false;         # Intel integrated graphics (usually auto-detected)

  # Connectivity hardware
  hasWifi = false;          # WiFi adapter (enables NetworkManager WiFi support)
  hasBluetooth = false;     # Bluetooth adapter
  hasEthernet = true;       # Wired ethernet (usually always true for desktops)

  # Input devices
  hasLogitechMouse = false; # Logitech mouse (enables logiops for button mapping)
  hasCustomKeyboard = false; # Custom keyboard fixes (e.g., Lofree Flow Fn keys)
  hasTouchpad = false;      # Laptop touchpad (enables touchpad gestures)
  hasTouchscreen = false;   # Touchscreen display

  # Biometric & Security
  hasYubikey = false;       # YubiKey hardware security key
  hasFingerprintSensor = false; # Fingerprint reader (enables fprintd)
  hasTPM = false;           # TPM chip (Trusted Platform Module)

  # Other peripherals
  hasPrinter = false;       # Printer support (enables CUPS)
  hasScanner = false;       # Scanner support (enables SANE)
  hasWebcam = false;        # Webcam (may need specific drivers)

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
