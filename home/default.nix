{ ... }:

let
  uiSettings = import ../modules/home/theme/settings.nix;
in
{
  # Make UI settings available to all modules
  _module.args.uiSettings = uiSettings;

  # Import all home modules
  # Note: niri home module is auto-imported by the NixOS module in flake.nix
  imports = [
    # Common packages and XDG settings
    ../modules/home

    # Shell
    ../modules/home/shell/nushell.nix
    ../modules/home/shell/starship.nix
    ../modules/home/shell/zoxide.nix
    ../modules/home/shell/atuin.nix

    # Editor
    ../modules/home/editor/helix.nix
    ../modules/home/editor/vscode.nix

    # Browser
    ../modules/home/browser/firefox.nix

    # Terminal
    ../modules/home/terminal/alacritty.nix

    # Compositor
    ../modules/home/compositor/common.nix
    ../modules/home/compositor/niri
    ../modules/home/compositor/launcher/vicinae.nix
    ../modules/home/compositor/notification/mako.nix

    # CLI tools
    ../modules/home/cli/core.nix
    ../modules/home/cli/monitor.nix
    ../modules/home/cli/file-manager.nix

    # Development tools
    ../modules/home/dev/git.nix
    ../modules/home/dev/direnv.nix

    # Services
    ../modules/home/service/ssh.nix
    ../modules/home/service/syncthing.nix

    # Theme
    ../modules/home/theme/gtk.nix
  ];

  # Stylix browser theming
  stylix.targets.firefox.profileNames = [ "default" ];
  stylix.targets.zen-browser.profileNames = [ "default" ];

  # State version - DO NOT CHANGE after initial install
  home.stateVersion = "25.05";
}
