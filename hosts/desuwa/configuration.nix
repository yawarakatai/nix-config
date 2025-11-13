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

  # Host-specific Nix settings (extends base.nix)
  nix.settings = {
    # Add Vicinae cache for this host
    substituters = [
      "https://vicinae.cachix.org"
    ];
    trusted-public-keys = [
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
    ];
  };

  # State version - DO NOT CHANGE after initial install
  system.stateVersion = "25.05";
}
