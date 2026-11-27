{ pkgs, ... }:

{
  wayland.windowManager.niri.settings = {
    xwayland-satellite.path = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";

    hotkey-overlay = {
      skip-at-startup = { };
      hide-not-bound = { };
    };

    _children = [
      # Make the active Wayland display available to commands run over SSH.
      {
        spawn-at-startup = [
          "${pkgs.dbus}/bin/dbus-update-activation-environment"
          "--systemd"
          "WAYLAND_DISPLAY"
          "XDG_CURRENT_DESKTOP"
          "XDG_SESSION_TYPE"
        ];
      }

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

    environment = {
      DISPLAY = ":0";
      XDG_CURRENT_DESKTOP = "niri";
    };
  };
}
