{ config, pkgs, vars, ... }:

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

  # Scanner support (SANE) - conditionally enabled if hasScanner is true
  services.saned.enable = vars.hasScanner or false;

  # Add scanner drivers
  hardware.sane = {
    enable = vars.hasScanner or false;
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
