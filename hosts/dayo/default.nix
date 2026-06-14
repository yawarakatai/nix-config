{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    # inputs.nixos-hardware.nixosModules.raspberry-pi-4

    ../../features/server/caddy.nix
    ../../features/server/containers/home-assistant.nix
    ../../features/server/gatus.nix
    ../../features/server/homepage-dashboard.nix
  ];

  boot.loader = {
    systemd-boot.enable = lib.mkForce true;
    generic-extlinux-compatible.enable = lib.mkForce false;
  };

  disko.devices.disk.main.device =
    lib.mkForce "/dev/disk/by-id/usb-BUFFALO_SSD-PSM_N_0020549205024243-0\:0";

  # === Firewall ===
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  # === Packages ===
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    htop
  ];

  services.caddy.virtualHosts."home.yawarakatai.com".extraConfig = ''
    reverse_proxy localhost:8082
  '';

  services.caddy.virtualHosts."gatus.yawarakatai.com".extraConfig = ''
    reverse_proxy localhost:3001
  '';

  services.caddy.virtualHosts."ha.yawarakatai.com".extraConfig = ''
    reverse_proxy localhost:8123
  '';
}
