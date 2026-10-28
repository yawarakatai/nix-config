{ pkgs, ... }:

{
  imports = [
    ../../../modules/profiles/home/desktop.nix
  ];

  programs.niri.settings.input.touchpad = {
    dwt = true;
    middle-emulation = true;
    scroll-method = "two-finger";
    accel-profile = "adaptive";
  };

  home.packages = with pkgs; [
    thunderbird
    slack
    libreoffice-qt
  ];
}
