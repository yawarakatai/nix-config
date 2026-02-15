{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
    file
    pciutils
    usbutils
  ];
}
