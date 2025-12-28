{ lib, inputs, config, pkgs, vars, ... }:

{
  imports = [
    # Core system modules
    ../../modules/system/boot.nix
    ../../modules/system/greetd.nix
    ../../modules/system/networking.nix
    ../../modules/system/locale.nix
    ../../modules/system/zram.nix
    ../../modules/system/storage.nix
    ../../modules/system/yubikey.nix
    ../../modules/system/audio.nix
    ../../modules/system/wayland.nix
  ];

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
    file
    pciutils
    usbutils
  ];

  # Hostname
  networking.hostName = vars.hostname;

  users = {
    mutableUsers = false;
    users.${vars.username} = {
      isNormalUser = true;
      description = vars.username;
      extraGroups = [ "networkmanager" "wheel" "video" "audio" "plugdev" ] ++ lib.optional config.virtualisation.docker.enable "docker";
      shell = pkgs.nushell;
    };
    users.root.hashedPassword = "!"; # Disable root login
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "root" vars.username ];
    };

    # gc = {
    #   automatic = true;
    #   dates = "weekly";
    #   options = "--delete-older-than 30d";
    # };

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

  services.openssh = {
    enable = false;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  services.gvfs.enable = true;

  programs.niri = {
    enable = true;
    package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;
  };

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 4d --keep 3";
    };
    flake = "/home/${vars.username}/.config/nix-config";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.dconf.enable = true;

  programs.xwayland.enable = true;

  nixpkgs.config.allowUnfree = true;
}
