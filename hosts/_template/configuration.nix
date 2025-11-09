{ config, pkgs, vars, ... }:

{
  imports = [
    # Shared base configuration (common settings for all hosts)
    ../../modules/system/base.nix

    # Core system modules (usually needed on all systems)
    ../../modules/system/boot.nix
    ../../modules/system/networking.nix
    ../../modules/system/locale.nix
    ../../modules/system/audio.nix
    ../../modules/system/zram.nix
    ../../modules/system/storage.nix
    ../../modules/system/rebuild-helper.nix
    ../../modules/system/wayland.nix
    ../../modules/system/niri-override.nix

    # Hardware-specific modules (uncomment what you need)
    # ../../modules/system/nvidia.nix          # NVIDIA GPU
    # ../../modules/system/bluetooth.nix       # Bluetooth
    # ../../modules/system/touchpad.nix        # Laptop touchpad
    # ../../modules/system/fingerprint.nix     # Fingerprint sensor
    # ../../modules/system/yubikey.nix         # YubiKey
    # ../../modules/system/logiops.nix         # Logitech mouse
    # ../../modules/system/keyboard.nix        # Custom keyboard fixes
    # ../../modules/system/printer.nix         # Printer/scanner
  ];

  # Hostname (required for each host)
  networking.hostName = vars.hostname;

  # User password (required for each host)
  # Generate password hash with: mkpasswd -m sha-512
  users.users.${vars.username}.hashedPassword = "YOUR_PASSWORD_HASH_HERE";

  # Optional: Limit boot generations
  boot.loader.systemd-boot.configurationLimit = 5;

  # State version - DO NOT CHANGE after initial install
  system.stateVersion = "25.05";
}
