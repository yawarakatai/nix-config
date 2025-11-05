{ config, pkgs, ... }:

{
  # YubiKey support packages
  environment.systemPackages = with pkgs; [
    yubikey-manager
    yubikey-personalization
    yubico-pam
  ];
  
  # GPG agent configuration for YubiKey
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };
  
  # Smart card support
  services.pcscd.enable = true;
  
  # USB auto-detection for YubiKey
  services.udev.packages = [ pkgs.yubikey-personalization ];
  
  # Optional: U2F/FIDO2 authentication
  # Uncomment to enable YubiKey for system login
  # security.pam.u2f = {
  #   enable = true;
  #   control = "sufficient";  # YubiKey or password
  #   # control = "required";  # YubiKey mandatory
  # };
}
