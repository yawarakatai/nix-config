{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    yubikey-manager
    yubikey-personalization
    yubico-pam
  ];

  # Smart card access for ykman.
  services.pcscd.enable = true;

  services.udev.packages = [ pkgs.yubikey-personalization ];
}
