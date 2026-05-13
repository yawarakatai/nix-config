{ pkgs, config, ... }:

{
  imports = [
    ./default.nix
    ../browser/firefox.nix
    ../terminal/alacritty.nix
    ../service/ssh-client.nix
    ../../gnome/home.nix
  ];

  home.packages = with pkgs; [
    nautilus
    loupe
    mpv
    pavucontrol
    playerctl
    brightnessctl
  ];

  stylix.targets.firefox.profileNames = [ "default" ];
  stylix.targets.zen-browser.profileNames = [ "default" ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
      "application/pdf" = "firefox.desktop";
      "image/*" = "org.gnome.loupe.desktop";
      "video/*" = "mpv.desktop";
    };
  };
}
