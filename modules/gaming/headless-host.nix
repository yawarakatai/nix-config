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
in
{
  environment.systemPackages = [ steamhostGui ];

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
        "${lib.getExe config.programs.steam.package} -tenfoot -pipewire-dmabuf"
      ];
      # Exiting Steam from a client must not leave the host down.
      Restart = "always";
      RestartSec = 5;
    };
  };
}
