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
    system.monitors.primary = {
      name = "DP-3";
      width = 3840;
      height = 2160;
      refresh = 144.000;
      scale = 1.0;
      vrr = true;
    };
    ui.scale = 1.25;
  };
}
