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
    # login.fprintAuth = true;
    greetd.fprintAuth = true;
    sudo.fprintAuth = true;
    polkit-1.fprintAuth = true;
  };
}
