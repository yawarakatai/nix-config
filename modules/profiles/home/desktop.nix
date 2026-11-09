{ ... }:

{
  imports = [
    ./default.nix
    ../../home/nix-config.nix
    ../../home/dev
    ../../home/services/ssh-client.nix
    ../../home/services/ssh-agenix.nix
    ../../home/services/gh-agenix.nix
    ../../home/services/ssh-agent.nix
    ../../home/services/syncthing.nix
    ../../home/browser/zen-browser.nix
    ../../home/terminal/ghostty.nix
    ../../home/desktop/apps.nix
    ../../home/desktop/input-method.nix
    ../../home/desktop/mime-apps.nix
    ../../desktop/niri/home
    ../../desktop/noctalia.nix
    ../../home/communication
  ];
}
