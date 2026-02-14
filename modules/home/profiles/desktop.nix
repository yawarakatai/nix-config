{ ... }:

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
    ../default.nix

    # Shell
    ../shell/nushell.nix
    ../shell/starship.nix
    ../shell/zoxide.nix
    ../shell/atuin.nix

    # Editor
    ../editor/helix.nix
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

    # CLI tools
    ../cli/core.nix
    ../cli/monitor.nix
    ../cli/file-manager.nix

    # Development tools
    ../dev/git.nix
    ../dev/direnv.nix

    # Services
    ../service/ssh-client.nix
    ../service/syncthing.nix
  ];

  # Stylix browser theming
  stylix.targets.firefox.profileNames = [ "default" ];
  stylix.targets.zen-browser.profileNames = [ "default" ];
}
