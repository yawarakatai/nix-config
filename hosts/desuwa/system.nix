{ pkgs, ... }:

{
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
      url = "https://w.wallhaven.cc/full/e8/wallhaven-e8vxwk.jpg";
      hash = "sha256-bPwkyksfXPUK4Ov8wmffpP1xYXwhXDfv5bg6N/0FsBA=";
    };
    ui.scale = 2.0;
  };
}
