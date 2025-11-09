{ config, pkgs, vars, ... }:

{
  imports = [
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

  # Display manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session";
        user = "greeter";
      };
    };
  };

  # Enable niri at system level to create session file for greetd
  programs.niri.enable = true;

  # Hostname
  networking.hostName = vars.hostname;

  # System packages (essential tools only, user packages in Home Manager)
  environment.systemPackages = with pkgs; [
    vim # Emergency editor
    git # Required for nixos-rebuild
    wget # Download utility
    curl # HTTP client
    file # File type identification
    pciutils # PCI device utilities (lspci)
    usbutils # USB device utilities (lsusb)
  ];

  # User configuration
  users = {
    mutableUsers = false;

    users.${vars.username} = {
      isNormalUser = true;
      description = vars.username;
      extraGroups = [ "networkmanager" "wheel" "video" "audio" "plugdev" ];
      shell = pkgs.nushell;

      # Generate password hash with: mkpasswd -m sha-512
      hashedPassword = "YOUR_PASSWORD_HASH_HERE";
    };

    # Disable root login
    users.root.hashedPassword = "!";
  };

  # Nix configuration
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "root" vars.username ];

      # Substituters
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    # Garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    # Optimize store
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      max-jobs = auto
    '';
  };

  # Limit boot generations
  boot.loader.systemd-boot.configurationLimit = 5;

  # SSH (disabled by default, enable when needed)
  services.openssh = {
    enable = false;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # direnv for per-project development environments
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # dconf for GTK application settings
  programs.dconf.enable = true;

  # XWayland support for X11 applications
  programs.xwayland.enable = true;

  # Allow unfree packages (NVIDIA driver, etc.)
  nixpkgs.config.allowUnfree = true;

  # State version - DO NOT CHANGE after initial install
  system.stateVersion = "25.05";
}
