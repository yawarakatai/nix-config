{ pkgs, ... }:

{
  # CUPS printing service
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      # Add printer drivers as needed:
      # gutenprint      # Wide range of printers
      # hplip           # HP printers
      # epson-escpr     # Epson printers
      # brlaser         # Brother laser printers
      # cnijfilter2     # Canon printers
    ];
  };

  # Scanner support (SANE)
  # Most printers have built-in scanners, so enable by default
  # Comment these out if you don't have a scanner
  services.saned.enable = true;

  hardware.sane = {
    enable = true;
    extraBackends = with pkgs; [
      # sane-airscan    # Network scanners
      # hplipWithPlugin # HP all-in-one devices
    ];
  };

  # Avahi for network printer discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
