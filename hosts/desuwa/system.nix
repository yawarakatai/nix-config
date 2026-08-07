{ pkgs, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    binfmt.emulatedSystems = [ "aarch64-linux" ];

    tmp = {
      useTmpfs = true;
      tmpfsSize = "50%";
    };
  };

  environment.sessionVariables = {
    __GL_SHADER_DISK_CACHE = "1";
    __GL_THREADED_OPTIMIZATION = "1";
  };

  services.kanata.keyboards.internal.devices = [
    "/dev/input/by-id/usb-CX_2.4G_Wireless_Receiver-event-kbd"
  ];

  my = {
    display.outputs = {
      "DP-3" = {
        primary = true;
        width = 3840;
        height = 2160;
        refresh = 144.000;
        scale = 1.0;
        vrr = true;
      };
    };
    wallpaper.image = pkgs.fetchurl {
      url = "https://github.com/dharmx/walls/blob/main/abstract/a_blue_and_orange_background.jpg?raw=true";
      hash = "sha256-pqjk+zuSAcvTYHF7uPnf+2uIFg4l7Waz6fGzOUVDwFI=";
    };
    ui.scale = 1.25;
  };
}
