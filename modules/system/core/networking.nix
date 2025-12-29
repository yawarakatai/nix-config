{ ... }:

{
  # Networking configuration
  networking = {
    # NetworkManager for easy network management
    networkmanager.enable = true;

    # Primary DNS: Cloudflare
    nameservers = [
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
    wireless.enable = false;
  };

  # DNS
  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    # Fallback DNS: Quad9
    fallbackDns = [
      "9.9.9.9"
      "149.112.112.112"
    ];
  };
}
