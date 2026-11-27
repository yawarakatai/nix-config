{ pkgs, ... }:

{
  imports = [
    ../../../modules/profiles/home/desktop.nix
  ];

  programs.noctalia.settings.wallpaper.enabled = false;

  wayland.windowManager.niri.settings.input.touchpad = {
    dwt = { };
    middle-emulation = { };
    scroll-method = "two-finger";
    accel-profile = "adaptive";
  };

  home.packages = with pkgs; [
    thunderbird
    slack
    libreoffice-qt
  ];
}
