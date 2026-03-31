{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
    file
    tree
    pciutils
    usbutils
  ];
}
