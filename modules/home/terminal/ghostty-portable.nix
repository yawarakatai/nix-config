{ pkgs, ... }:

{
  imports = [ ./ghostty.nix ];

  # Nix-built Ghostty needs host GPU drivers; use the distribution's package.
  programs.ghostty = {
    package = null;
    systemd.enable = false;
  };

  # Fonts referenced by the Ghostty configuration; desktop hosts get them from Stylix.
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];
}
