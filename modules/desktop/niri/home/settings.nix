{ pkgs, ... }:

{
  wayland.windowManager.niri.settings = {
    hotkey-overlay = {
      skip-at-startup = { };
      hide-not-bound = { };
    };

    _children = [
      # Keep a headless Ghostty GTK instance ready for +new-window. This avoids
      # paying GTK/font initialization cost when opening the first terminal.
      {
        spawn-at-startup = [
          "${pkgs.ghostty}/bin/ghostty"
          "--gtk-single-instance=true"
          "--initial-window=false"
          "--quit-after-last-window-closed=false"
        ];
      }
    ];

    animations.slowdown = 1.0;

    prefer-no-csd = { };

    # Niri's default is under ~/Pictures, which xdg.userDirs avoids creating;
    # niri creates this directory on the first save.
    screenshot-path = "~/.screenshots/%Y-%m-%d_%H-%M-%S.png";
  };
}
