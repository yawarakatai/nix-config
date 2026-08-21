{ pkgs, ... }:

{
  programs.niri.settings = {
    xwayland-satellite.path = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";

    hotkey-overlay = {
      skip-at-startup = true;
      hide-not-bound = true;
    };

    # Make the active Wayland display available to commands run over SSH.
    spawn-at-startup = [
      {
        argv = [
          "${pkgs.dbus}/bin/dbus-update-activation-environment"
          "--systemd"
          "WAYLAND_DISPLAY"
          "XDG_CURRENT_DESKTOP"
          "XDG_SESSION_TYPE"
        ];
      }
    ];

    animations = {
      enable = true;
      slowdown = 1.0;
    };

    prefer-no-csd = true;

    environment = {
      DISPLAY = ":0";
      XDG_CURRENT_DESKTOP = "niri";
    };
  };
}
