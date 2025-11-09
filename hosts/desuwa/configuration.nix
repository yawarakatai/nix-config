{ config, pkgs, vars, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions /run/current-system/sw/share/wayland-sessions";
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

      # Initial password hash - generate with: mkpasswd -m sha-512
      hashedPassword = "$6$KtMQPtEMmQ9AW7qK$tvtWeUA5GzWyILnexkH51.OMTnM6cuzA2aEymac264HctHr5jRBH7NBOOn4twZqaF963f8KkgDdNzfpSfd54D0";

      # TODO: Set up sops-nix for secrets management
      # 1. Initialize sops with age or GPG key
      # 2. Create secrets file in secrets/ directory
      # 3. Uncomment and configure: hashedPasswordFile = config.sops.secrets.yawarakatai-password.path;
      # 4. Set up sops configuration in flake.nix if not already done
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
        "https://vicinae.cachix.org" # Vicinae cache
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc=" # Vicinae cache key
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
  # Required for home-manager GTK configuration and GNOME apps like Nautilus
  programs.dconf.enable = true;

  # XWayland support for X11 applications
  programs.xwayland.enable = true;

  # Allow unfree packages (NVIDIA driver, etc.)
  nixpkgs.config.allowUnfree = true;

  # State version - DO NOT CHANGE after initial install
  system.stateVersion = "25.05";
}
