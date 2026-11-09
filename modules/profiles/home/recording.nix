{ pkgs, ... }:

{
  # Keep accounts, credentials, and personal sync out of recorded sessions.
  imports = [
    ./default.nix
    ../../home/dev
    ../../home/browser/zen-browser.nix
    ../../home/terminal/ghostty.nix
    ../../home/desktop/apps.nix
    ../../home/desktop/input-method.nix
    ../../home/desktop/mime-apps.nix
    ../../desktop/niri/home
    ../../desktop/noctalia.nix
  ];

  home.packages = [ pkgs.gpu-screen-recorder ];
}
