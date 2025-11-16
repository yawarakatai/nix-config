{ config, pkgs, vars, ... }:

{
  # Networking configuration
  networking = {
    # NetworkManager for easy network management
    networkmanager.enable = true;
    
    # Firewall
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
      
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
    # Primary DNS: Cloudflare
    dns = [ "1.1.1.1" "1.0.0.1" ];
    # Fallback DNS: Quad9
    fallbackDns = [ "9.9.9.9" "149.112.112.112" ];
  };
}
