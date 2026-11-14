_:

{
  networking.firewall = {
    enable = true;
    allowPing = true;
  };

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
