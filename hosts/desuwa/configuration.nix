{ pkgs, vars, ... }:

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
    ../../modules/system/wayland.nix
    ../../modules/system/niri-override.nix

    # Hardware-specific modules for this host
    ../../modules/system/nvidia.nix # NVIDIA RTX 3080
    ../../modules/system/yubikey.nix # YubiKey support
    ../../modules/system/logiops.nix # Logitech mouse
    ../../modules/system/lofreeflowlite.nix # Lofree Flow keyboard

    ../../modules/system/cross-compilation.nix
  ];

  # Hostname
  networking.hostName = vars.hostname;

  # Host-specific user password
  # Password hash generated with: mkpasswd -m sha-512
  users.users.${vars.username}.hashedPassword = "$6$KtMQPtEMmQ9AW7qK$tvtWeUA5GzWyILnexkH51.OMTnM6cuzA2aEymac264HctHr5jRBH7NBOOn4twZqaF963f8KkgDdNzfpSfd54D0";

  services.flatpak.enable = true;

  # Enable Steam with proper FHS environment
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Steam Remote Play
    dedicatedServer.openFirewall = true; # Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true;

    gamescopeSession.enable = true; # Gamescope compositor for better Wayland support

    # Additional compatibility packages
    extraCompatPackages = with pkgs; [ proton-ge-bin ];

    # Package overrides for additional library compatibility
    package = pkgs.steam.override {
      extraEnv = {
        # Skip X11 update UI that fails on Wayland-only compositors
        STEAM_UPDATE_UI = "0";
      };
      extraLibraries = pkgs: with pkgs; [
        # Additional libraries for X11 compatibility
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver

        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
      ];
    };
  };

  environment.sessionVariables = {
    __GL_SHADER_DISK_CACHE = "1";
    __GL_THREADED_OPTIMIZATION = "1";
  };

  # Those are for when Davinci Resolve won't work well
  # environment.systemPackages = with pkgs; [
  #   ocl-icd
  # ];

  # hardware.graphics = {
  #   enable = true;
  #   extraPackages = with pkgs; [
  #     nvidia-vaapi-driver
  #     ocl-icd
  #     opencl-headers
  #   ];
  # };

  # Host-specific Nix settings (extends base.nix)
  nix.settings = { };

  # Tmp on tmpfs for better performance
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "50%";
  };

  # State version - DO NOT CHANGE after initial install
  system.stateVersion = "25.05";
}
