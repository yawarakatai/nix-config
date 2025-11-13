{ config, pkgs, vars, ... }:

{
  imports = [
    # Shared base configuration (common settings for all hosts)
    ../../modules/system/base.nix

    # Core system modules
    ../../modules/system/boot.nix
    ../../modules/system/networking.nix
    ../../modules/system/locale.nix
    ../../modules/system/audio.nix
    ../../modules/system/zram.nix
    ../../modules/system/storage.nix
    ../../modules/system/rebuild-helper.nix
    ../../modules/system/wayland.nix
    ../../modules/system/niri-override.nix

    # Hardware-specific modules for this host
    ../../modules/system/nvidia.nix # NVIDIA RTX 3080
    ../../modules/system/yubikey.nix # YubiKey support
    ../../modules/system/logiops.nix # Logitech mouse
    ../../modules/system/lofreeflowlite.nix # Lofree Flow keyboard
  ];

  # Hostname
  networking.hostName = vars.hostname;

  # Host-specific user password
  # Password hash generated with: mkpasswd -m sha-512
  users.users.${vars.username}.hashedPassword = "$6$KtMQPtEMmQ9AW7qK$tvtWeUA5GzWyILnexkH51.OMTnM6cuzA2aEymac264HctHr5jRBH7NBOOn4twZqaF963f8KkgDdNzfpSfd54D0";

  # Enable Steam with proper FHS environment
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Steam Remote Play
    dedicatedServer.openFirewall = true; # Source Dedicated Server
    gamescopeSession.enable = true; # Gamescope compositor for better Wayland support

    # Additional compatibility packages
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };

  # Steam needs XWayland support on Wayland systems
  programs.xwayland.enable = true;

  # Host-specific Nix settings (extends base.nix)
  nix.settings = { };

  # State version - DO NOT CHANGE after initial install
  system.stateVersion = "25.05";
}
