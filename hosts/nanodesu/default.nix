{ lib, pkgs, ... }:

{
  imports = [
    (import ../../features/storage/disko-btrfs-luks.nix {
      device = "/dev/disk/by-id/nvme-eui.044a5001b15002a8";
      luksName = "cryptoroot";
    })
    ./hardware-configuration.nix
    ../../features/input/touchpad.nix
    ../../features/hardware/bluetooth.nix
    ../../features/laptop/fingerprint.nix
    ../../features/laptop/power.nix
    ../../features/hardware/webcam.nix
  ];

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

  # Workaround for Alder Lake audio firmware signature verification failure
  boot.kernelParams = [ "snd_intel_dspcfg.dsp_driver=1" ];

  # --- Application and Service Settings ---;
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchDocked = "suspend";
    HandleLidSwitchExternalPower = "suspend";
  };

  # --- My Options ---

  my = {
    system.monitors.primary = (import ../../displays).nanodesu-builtin;
  };

  # --- State Version ---
  system.stateVersion = "25.05";
}
