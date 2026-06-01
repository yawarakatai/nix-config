{ pkgs, ... }:

{
  imports = [
    ./default.nix
    ../browser/zen-browser.nix
    ../terminal/alacritty.nix
    ../compositor/common.nix
    ../../niri/home
    ../compositor/launcher/vicinae.nix
    ../compositor/notification/mako.nix
    ../service/ssh-client.nix
    ../../desktop/waybar.nix
  ];

  gtk.gtk4.theme = null;

  home.packages = with pkgs; [
    nautilus
    loupe
    mpv
    pavucontrol
    playerctl
    brightnessctl
    blueman
    wlogout
  ];

  xdg.configFile = {
    "wlogout/layout".source = ../wlogout/layout;
    "wlogout/style.css".source = ../wlogout/style.css;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "zen-beta.desktop";
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "x-scheme-handler/about" = "zen-beta.desktop";
      "x-scheme-handler/unknown" = "zen-beta.desktop";
      "application/pdf" = "zen-beta.desktop";
      "image/*" = "org.gnome.loupe.desktop";
      "video/*" = "mpv.desktop";
    };
  };
}
