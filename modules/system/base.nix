# Shared base system configuration
# Contains common settings used across all hosts
{ config, pkgs, vars, ... }:

{
  # Essential system packages (same across all hosts)
  environment.systemPackages = with pkgs; [
    vim # Emergency editor
    git # Required for nixos-rebuild
    wget # Download utility
    curl # HTTP client
    file # File type identification
    pciutils # PCI device utilities (lspci)
    usbutils # USB device utilities (lsusb)
  ];

  # User configuration defaults
  users = {
    mutableUsers = false;

    users.${vars.username} = {
      isNormalUser = true;
      description = vars.username;
      extraGroups = [ "networkmanager" "wheel" "video" "audio" "plugdev" ];
      shell = pkgs.nushell;
    };

    # Disable root login for security
    users.root.hashedPassword = "!";
  };

  # Nix daemon and package manager configuration
  nix = {
    settings = {
      # Enable flakes and nix-command
      experimental-features = [ "nix-command" "flakes" ];

      # Automatically optimize the store
      auto-optimise-store = true;

      # Trusted users who can use extra-experimental features
      trusted-users = [ "root" vars.username ];

      # Binary caches for faster builds
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://vicinae.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
      ];
    };

    # Automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    # Automatic store optimization
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    # Additional Nix options
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      max-jobs = auto
    '';
  };

  # Display manager - greetd with regreet (GTK4 graphical greeter)
  # Regreet requires a Wayland compositor to run - using minimal niri config
  # Running on niri instead of cage for better compatibility (especially VMs)
  programs.regreet = {
    enable = true;

    # Theme configuration for regreet
    # Using Colloid theme to match GNOME configuration
    theme = {
      name = "Colloid-Grey-Dark";
      package = pkgs.colloid-gtk-theme.override {
        themeVariants = [ "grey" ];
        colorVariants = [ "dark" ];
        sizeVariants = [ "standard" ];
        tweaks = [ "black" "rimless" "normal" ];
      };
    };

    iconTheme = {
      name = "Colloid-Grey";
      package = pkgs.colloid-icon-theme.override {
        colorVariants = [ "grey" ];
      };
    };

    cursorTheme = {
      name = "graphite-dark";
      package = pkgs.graphite-cursors;
    };

    font = {
      name = "Sans";
      size = 11;
      package = pkgs.dejavu_fonts;
    };
  };

  # Configure greetd to use regreet with minimal niri compositor
  # Minimal niri config that spawns regreet and quits after login
  services.greetd =
    let
      # Minimal niri configuration for greeter
      # Spawns regreet at startup and quits niri after login completes
      minimumConfig = pkgs.writeText "minimum-config.kdl" ''
        hotkey-overlay {
          skip-at-startup
        }
        spawn-at-startup "sh" "-c" "${pkgs.lib.getExe pkgs.greetd.regreet}; niri msg action quit --skip-confirmation"
      '';
    in
    {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.lib.getExe config.programs.niri.package} --config ${minimumConfig}";
          user = "greeter";
        };
      };
    };

  # Commented out tuigreet configuration (TUI greeter alternative)
  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session";
  #       user = "greeter";
  #     };
  #   };
  # };

  # Enable niri at system level (creates session file for greetd)
  programs.niri.enable = true;

  # SSH daemon (disabled by default for security)
  services.openssh = {
    enable = false;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # Required for trash functionality
  services.gvfs.enable = true;

  # direnv for per-project development environments
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # dconf for GTK application settings
  # Required for home-manager GTK configuration and GNOME apps
  programs.dconf.enable = true;

  # XWayland support for X11 applications
  programs.xwayland.enable = true;

  # Allow unfree packages (NVIDIA drivers, etc.)
  nixpkgs.config.allowUnfree = true;
}
