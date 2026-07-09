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
      url = "https://i.redd.it/mg5w8i3gkstg1.jpeg";
      hash = "sha256-02EacG9i2c4puqQ5VRVPTBZmZDInA8pBC8QG9IMJEn8=";
    };
    ui.scale = 1.25;
  };
}
