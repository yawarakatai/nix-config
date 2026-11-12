{ pkgs, ... }:

{
  # Keep secrets, personal sync, and messaging out of recorded sessions; the
  # public Git identity is fine.
  imports = [
    ./default.nix
    ../../home/dev
    ../../home/dev/agents.nix
    ../../home/dev/git-identity.nix
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
