{
  lib,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    sbctl
  ];

  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    initrd.luks.devices."cryptoroot" = {
      crypttabExtraOpts = [
        "tmp2-device=auto"
        "tmp2-pcrs=7"
      ];
    };
  };

  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
  };

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
    ui.scale = 1.25;
  };
}
