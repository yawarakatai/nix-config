# Steam Remote Play host that runs from boot, without a login or a display.
# A dedicated user keeps it out of the desktop session; see the host README
# for the first Steam login and library migration.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  user = "steamhost";
  steam = lib.getExe config.programs.steam.package;

  # Shows a steamhost program, such as BSManager, on the caller's desktop.
  # A full steamhost desktop login was rejected: it would need a password and a
  # second desktop setup, and the headless Steam would have to stop meanwhile.
  steamhostGui = pkgs.writeShellApplication {
    name = "steamhost-gui";
    runtimeInputs = [ pkgs.xhost ];
    text = ''
      program=$(command -v "$1")
      shift
      xhost +SI:localuser:${user} >/dev/null
      trap 'xhost -SI:localuser:${user} >/dev/null' EXIT
      sudo machinectl shell ${user}@ /run/current-system/sw/bin/env DISPLAY="$DISPLAY" "$program" "$@"
    '';
  };

  # Steam's window close button only hides it in a tray that steamhost has
  # nowhere to show, and STEAM_FRAME_FORCE_CLOSE=1 no longer changes that
  # (verified), so this quits Steam from the terminal instead. A transient unit
  # lets the terminal stay free and cleans up whatever Steam leaves behind.
  steamhostLogin = pkgs.writeShellApplication {
    name = "steamhost-login";
    runtimeInputs = [
      pkgs.procps
      pkgs.xhost
    ];
    text = ''
      ctl() { sudo systemctl --user -M ${user}@ "$@"; }
      as_user() { sudo systemd-run --user -M ${user}@ --quiet "$@"; }
      steam_running() { pgrep -u ${user} -f steamrt64/steam >/dev/null; }
      cleanup() {
        ctl stop steam-login 2>/dev/null || true
        xhost -SI:localuser:${user} >/dev/null
        ctl start steam-headless
      }

      # Only one Steam can run per user.
      ctl stop steam-headless
      xhost +SI:localuser:${user} >/dev/null
      trap cleanup EXIT

      as_user --unit=steam-login --collect -p RemainAfterExit=yes \
        --setenv=DISPLAY="$DISPLAY" ${steam}

      read -rp "Log in, then press Enter here to quit Steam: "
      if steam_running; then
        as_user --wait ${steam} -shutdown
        for _ in $(seq 30); do
          steam_running || break
          sleep 1
        done
      fi
    '';
  };
in
{
  environment.systemPackages = [
    steamhostGui
    steamhostLogin
  ];

  users.groups.${user} = { };
  users.users.${user} = {
    # Steam keeps its client and library in the home directory.
    isNormalUser = true;
    group = user;
    description = "Headless Steam Remote Play host";
    # Starts the user manager at boot; the account has no password.
    linger = true;
    extraGroups = [
      # Seat ACLs (uaccess) never apply without a login session.
      "input" # games read Steam's virtual controllers through evdev
      "uinput" # Steam creates those virtual controllers
      "networkmanager" # Steam drives the Steam Frame adapter through NetworkManager
    ];
  };

  hardware.uinput.enable = true;

  # Valve's rules grant these devices only to the seat user; Steam also talks to
  # the Steam Frame adapter over USB.
  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="28de", GROUP="${user}"
  '';

  systemd.user.services.steam-headless = {
    description = "Headless Steam for Remote Play";
    unitConfig.ConditionUser = user;
    wantedBy = [ "default.target" ];
    wants = [ "pipewire.service" ];
    after = [ "pipewire.service" ];
    serviceConfig = {
      # Verified on the RTX 3080: dmabuf import fails inside Steam's runtime and
      # falls back to shared memory, which still captures in under 1 ms.
      ExecStart = lib.concatStringsSep " " [
        "${config.security.wrapperDir}/gamescope"
        "--backend headless -W 1920 -H 1080 --steam --"
        "${steam} -tenfoot -pipewire-dmabuf"
      ];
      # Exiting Steam from a client must not leave the host down.
      Restart = "always";
      RestartSec = 5;
    };
  };
}
