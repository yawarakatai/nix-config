{ pkgs, ... }:

let
  uiSettings = import ../theme/settings.nix;
in
{
  # Make UI settings available to all modules
  _module.args.uiSettings = uiSettings;

  # Import all home modules
  # Note: niri home module is auto-imported by the NixOS module in flake.nix
  imports = [
    # Common packages and XDG settings
    ./default.nix

    # Editor
    ../editor/vscode.nix

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
    ../service/syncthing.nix
  ];

  # Common packages used across all home configurations
  # These are everyday utilities that every user profile should have
  home.packages = with pkgs; [
    # File manager
    nautilus

    # Image viewer
    imv

    # Media and system controls
    pavucontrol # PulseAudio volume control GUI
    playerctl # Media player controls
    brightnessctl # Brightness controls
  ];
  # Stylix browser theming
  stylix.targets.firefox.profileNames = [ "default" ];
  stylix.targets.zen-browser.profileNames = [ "default" ];
}
