{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../lib/options.nix
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.raspberry-pi-4

    # Server containers
    ../../modules/system/server/containers/home-assistant.nix
    # ../../modules/system/server/uptime-kuma.nix
    ../../modules/system/server/gatus.nix
    ../../modules/system/server/homepage-dashboard.nix
  ];

  # === Boot ===
  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
  };
  boot.kernelParams = lib.mkForce [ ];

  # === Hardware ===
  hardware.raspberry-pi."4".fkms-3d.enable = false;

  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # === Locale ===
  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  # === User ===
  my.user.name = "yawarakatai";
  users.users.yawarakatai.shell = lib.mkForce pkgs.bash;

  # === Firewall ===
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  # === Packages ===
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    htop
    lm_sensors
  ];

  system.stateVersion = "25.05";
}
