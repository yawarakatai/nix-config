{ pkgs, ... }:

{
  imports = [
    ./core
    ./security
    ./service
    ./storage
  ];

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
