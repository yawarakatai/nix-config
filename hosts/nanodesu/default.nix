{ pkgs, ... }:

{
  imports = [
    (import ../../modules/system/storage/disko-btrfs.nix {
      device = "/dev/disk/by-id/nvme-eui.044a5001b15002a8";
    })
    ./hardware-configuration.nix

    # Laptop-specific hardware modules
    ../../modules/system/input/touchpad.nix
    ../../modules/system/hardware/bluetooth.nix
    ../../modules/system/laptop/fingerprint.nix
    ../../modules/system/laptop/power.nix
    ../../modules/system/hardware/webcam.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Workaround for Alder Lake audio firmware signature verification failure
  boot.kernelParams = [
    "snd_intel_dspcfg.dsp_driver=1"
  ];

  # --- Application and Service Settings ---;
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchDocked = "suspend";
    HandleLidSwitchExternalPower = "suspend";
  };

  # --- My Options ---

  my = {
    system.monitors.primary = {
      name = "eDP-1";
      width = 2160;
      height = 1350;
      refresh = 59.940;
    };
  };

  # --- State Version ---
  system.stateVersion = "25.05";
}
