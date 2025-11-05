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
    fallbackDns = [ "1.1.1.1" "8.8.8.8" ];
  };
}
