{ ... }:

{
  imports = [
    ./default.nix
    ../../home/nix-config.nix
    ../../home/dev
    ../../home/dev/claude-code.nix
    ../../home/dev/git-identity.nix
    ../../ssh/home.nix
    ../../github/home.nix
    ../../syncthing/home.nix
    ../../home/browser/zen-browser.nix
    ../../home/terminal/ghostty.nix
    ../../home/desktop/apps.nix
    ../../home/desktop/input-method.nix
    ../../home/desktop/mime-apps.nix
    ../../desktop/niri/home
    ../../desktop/noctalia/home.nix
    ../../home/communication
  ];
}
