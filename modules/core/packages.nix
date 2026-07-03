{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    file
    pciutils
    usbutils
  ];
}
