{ ... }:
{
  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers.adguard = {
    image = "adguard/adguardhome:latest";
    ports = [
      "3000:3000"
      "8053:80"
      "53:53/tcp"
      "53:53/udp"
    ];
    volumes = [
      "/var/lib/adguard/work:/opt/adguardhome/work"
      "/var/lib/adguard/conf:/opt/adguardhome/conf"
    ];
  };

  services.resolved.settings.Resolve.DNSStubListener = "no";

  networking.firewall = {
    allowedUDPPorts = [ 53 ];
    allowedTCPPorts = [ 53 ];
  };
}
