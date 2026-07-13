{
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  niriSession = "${config.programs.niri.package}/bin/niri-session";
in
{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.tmp.useTmpfs = lib.mkForce false;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
    priority = 100;
  };

  hardware.enableRedistributableFirmware = true;

  services = {
    power-profiles-daemon.enable = true;
    upower.enable = true;
    fwupd.enable = true;

    logind.settings.Login = {
      HandlePowerKey = "ignore";
      HandlePowerKeyLongPress = "ignore";
    };

    acpid = {
      enable = true;
      logEvents = true;

      powerEventCommands = ''
        niri_socket="$(
          find /run/user/* \
            -maxdepth 1 \
            -type s \
            -name 'niri*.sock' \
            -print \
            -quit 2>/dev/null
        )"

        if [ -z "$niri_socket" ]; then
          echo "No active niri socket found" >&2
          exit 1
        fi

        socket_uid="$(${pkgs.coreutils}/bin/stat -c %u "$niri_socket")"
        socket_user="$(${pkgs.coreutils}/bin/id -nu "$socket_uid")"

        ${pkgs.util-linux}/bin/runuser \
          -u "$socket_user" \
          -- ${pkgs.coreutils}/bin/env \
          NIRI_SOCKET="$niri_socket" \
          ${config.programs.niri.package}/bin/niri \
          msg action power-off-monitors
      '';
    };
  };

  hardware.asus.battery.chargeUpto = 80;

  services.greetd.settings.initial_session = {
    command = niriSession;
    user = username;
  };

  environment.systemPackages = with pkgs; [
    wvkbd
    wlr-randr
    brightnessctl
    playerctl
    powertop
    lm_sensors
    usbutils
    pciutils
  ];

  my = {
    display.outputs = {
      "eDP-1" = {
        primary = true;
        width = 1920;
        height = 1080;
        refresh = 59.999;
        scale = 1.0;
        vrr = true;
      };
      "DP-2" = {
        enable = false;
      };
    };
    wallpaper.image = pkgs.fetchurl {
      url = "https://i.redd.it/mg5w8i3gkstg1.jpeg";
      hash = "sha256-02EacG9i2c4puqQ5VRVPTBZmZDInA8pBC8QG9IMJEn8=";
    };
    ui.scale = 2.0;
  };
}
