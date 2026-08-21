{ ... }:

{
  imports = [
    ./default.nix
    ../../home/browser/zen-browser.nix
    ../../home/services/ssh-client.nix
    ../../home/services/ssh-agenix.nix
    ../../home/dev
    ../../home/terminal/ghostty.nix
    ../../home/desktop/apps.nix
    ../../home/desktop/input-method.nix
    ../../home/desktop/mime-apps.nix
    ../../theme/home.nix
  ];
}
