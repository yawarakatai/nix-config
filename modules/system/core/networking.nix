{ ... }:

{
  # Networking configuration
  networking = {
    # NetworkManager for easy network management
    networkmanager.enable = true;

    # Primary DNS: Cloudflare
    networkmanager.insertNameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];

    # Firewall
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22000 ];
      allowedUDPPorts = [
        22000
        21027
      ];

      # Allow DHCP
      allowPing = true;
    };

    # Disable wireless (using NetworkManager instead)
    # wireless.enable = lib.mkForce false;
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  # DNS
  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = "allow-downgrade";

      FallbackDNS = [
        "9.9.9.9"
        "149.112.112.112"
      ];
    };
  };
}
