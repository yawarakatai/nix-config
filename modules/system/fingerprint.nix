{ config, pkgs, vars, ... }:

{
  # Fingerprint reader support (fprintd)
  services.fprintd = {
    enable = true;
    # Optional: enable TOD (Touch OEM Drivers) for newer sensors
    # tod.enable = true;
    # tod.driver = pkgs.libfprint-2-tod1-goodix; # Example for Goodix sensors
  };

  # PAM configuration for fingerprint authentication
  security.pam.services = {
    login.fprintAuth = true;
    sudo.fprintAuth = true;
    # Optionally enable for other services
    # polkit.fprintAuth = true;
    # gdm.fprintAuth = true;
  };
}
