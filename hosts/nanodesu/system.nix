{
  pkgs,
  ...
}:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelParams = [ "snd_intel_dspcfg.dsp_driver=1" ];

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchDocked = "suspend";
    HandleLidSwitchExternalPower = "suspend";
  };

  my = {
    display.outputs = {
      "eDP-1" = {
        primary = true;
        width = 2160;
        height = 1350;
        refresh = 59.940;
        scale = 1.0;
        vrr = false;
      };
    };
    ui.scale = 1.0;
  };
}
