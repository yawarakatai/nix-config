{ pkgs, ... }:

{
  # Import all home modules
  # Note: niri home module is auto-imported by the NixOS module in flake.nix
  imports = [
    # Common packages and XDG settings
    ./default.nix

    # Browser
    ../browser/firefox.nix

    # Terminal
    ../terminal/alacritty.nix

    # Compositor
    ../compositor/common.nix
    ../compositor/niri
    ../compositor/launcher/vicinae.nix
    ../compositor/notification/mako.nix

    # Services
    ../service/ssh-client.nix
  ];

  # GTK4 theme - use null (new default) since Stylix handles theming
  gtk.gtk4.theme = null;

  # Common packages used across all home configurations
  home.packages = with pkgs; [
    nautilus
    loupe
    mpv

    # Media and system controls
    pavucontrol # PulseAudio volume control GUI
    playerctl # Media player controls
    brightnessctl # Brightness controls
  ];
  # Stylix browser theming
  stylix.targets.firefox.profileNames = [ "default" ];
  stylix.targets.zen-browser.profileNames = [ "default" ];
}
