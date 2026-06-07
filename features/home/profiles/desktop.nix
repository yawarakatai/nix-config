{ pkgs, ... }:

{
  imports = [
    ./default.nix
    ../browser/zen-browser.nix
    ../terminal/alacritty.nix
    ../service/ssh-client.nix
  ];

  home.packages = with pkgs; [
    nautilus
    loupe
    mpv
    pavucontrol
    playerctl
    brightnessctl
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "zen-beta.desktop";
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "x-scheme-handler/about" = "zen-beta.desktop";
      "x-scheme-handler/unknown" = "zen-beta.desktop";
      "application/pdf" = "zen-beta.desktop";
      "image/bmp" = "loupe.desktop";
      "image/gif" = "loupe.desktop";
      "image/heif" = "loupe.desktop";
      "image/avif" = "loupe.desktop";
      "image/jpeg" = "loupe.desktop";
      "image/jpg" = "loupe.desktop";
      "image/jxl" = "loupe.desktop";
      "image/png" = "loupe.desktop";
      "image/svg+xml" = "loupe.desktop";
      "image/tiff" = "loupe.desktop";
      "image/webp" = "loupe.desktop";
      "video/mp4" = "mpv.desktop";
      "video/mkv" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
      "video/avi" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
    };
  };
}
