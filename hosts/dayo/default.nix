{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.raspberry-pi-4

    # Server containers
    ../../modules/system/server/containers/home-assistant.nix
    ../../modules/system/server/gatus.nix
    ../../modules/system/server/homepage-dashboard.nix
  ];

  # === Locale ===
  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  # === Firewall ===
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  # === Packages ===
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    htop
  ];

  system.stateVersion = "25.05";
}
