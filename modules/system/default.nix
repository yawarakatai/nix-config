# Base system configuration - minimal common settings
{
  inputs,
  pkgs,
  vars,
  ...
}:

{
  imports = [
    # Core system modules
    ./core/boot.nix
    ./core/networking.nix
    ./core/locale.nix
    ./core/users.nix
    ./core/nix.nix

    # Display
    ./display/greetd.nix
    ./display/wayland.nix

    # Hardware
    ./hardware/audio.nix

    # Storage
    ./storage/btrfs.nix
    ./storage/zram.nix

    # Security
    ./security/yubikey.nix

    # Services
    ./service/ssh.nix
  ];

  # Agenix-rekey configuration
  age.rekey = {
    # Host public key for rekeying (from /etc/ssh/ssh_host_ed25519_key.pub)
    hostPubkey = "/etc/ssh/ssh_host_ed25519_key.pub";

    # Master identity (YubiKey FIDO2)
    masterIdentities = [ ../../secrets/master-key.pub ];

    # Use local storage mode
    storageMode = "local";
    localStorageDir = ../../secrets/rekeyed/${vars.hostname};

    # FIDO2 plugin for YubiKey
    agePlugins = [ pkgs.age-plugin-fido2-hmac ];
  };

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

  services.gvfs.enable = true;

  programs.niri = {
    enable = true;
    package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;
  };

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 4d --keep 5";
    };
    flake = "/home/${vars.username}/.config/nix-config";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.dconf.enable = true;

  programs.xwayland.enable = true;
}
