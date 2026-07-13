{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "clip-send" ''
      set -eu

      if [ "$#" -ne 1 ]; then
        echo "usage: clip-send HOST" >&2
        exit 64
      fi

      ${pkgs.wl-clipboard}/bin/wl-paste --no-newline |
        ${pkgs.openssh}/bin/ssh "$1" '
          set -eu

          runtime="/run/user/$(id -u)"
          export XDG_RUNTIME_DIR="$runtime"
          export DBUS_SESSION_BUS_ADDRESS="unix:path=$runtime/bus"

          display="$(
            systemctl --user show-environment |
              sed -n "s/^WAYLAND_DISPLAY=//p" |
              head -n 1
          )"

          if [ -z "$display" ]; then
            echo "WAYLAND_DISPLAY is not registered in the user systemd environment" >&2
            exit 1
          fi

          WAYLAND_DISPLAY="$display" wl-copy
        '
    '')

    (pkgs.writeShellScriptBin "clip-get" ''
      set -eu

      if [ "$#" -ne 1 ]; then
        echo "usage: clip-get HOST" >&2
        exit 64
      fi

      ${pkgs.openssh}/bin/ssh "$1" '
        set -eu

        runtime="/run/user/$(id -u)"
        export XDG_RUNTIME_DIR="$runtime"
        export DBUS_SESSION_BUS_ADDRESS="unix:path=$runtime/bus"

        display="$(
          systemctl --user show-environment |
            sed -n "s/^WAYLAND_DISPLAY=//p" |
            head -n 1
        )"

        if [ -z "$display" ]; then
          echo "WAYLAND_DISPLAY is not registered in the user systemd environment" >&2
          exit 1
        fi

        WAYLAND_DISPLAY="$display" wl-paste --no-newline
      ' |
        ${pkgs.wl-clipboard}/bin/wl-copy
    '')
  ];
}
