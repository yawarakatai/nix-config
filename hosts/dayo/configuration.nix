{ config, pkgs, vars, ... }:

{
  imports = [
    # Shared base configuration
    ../../modules/system/base.nix

    # Minimal system modules for server
    ../../modules/system/boot.nix
    ../../modules/system/networking.nix
    ../../modules/system/locale.nix
    ../../modules/system/zram.nix
    ../../modules/system/storage.nix
    ../../modules/system/rebuild-helper.nix
  ];

  # Hostname
  networking.hostName = vars.hostname;

  # User password
  # Generate password hash with: mkpasswd -m sha-512
  users.users.${vars.username}.hashedPassword = "$6$rounds=656000$ExampleHashPlaceholder$ExampleHashPlaceholderExampleHashPlaceholderExampleHashPlaceholderExampleHashPlaceholder";

  # Limit boot generations
  boot.loader.systemd-boot.configurationLimit = 5;

  # State version - DO NOT CHANGE after initial install
  system.stateVersion = "25.05";
}
