{ pkgs, ... }:

{
  imports = [
    (import ../../modules/system/storage/disko-btrfs.nix {
      device = "/dev/disk/by-id/ata-BC711_NVMe_SK_hynix_256GB_CSA5N48991030585U";
    })
    ./hardware-configuration.nix
    ../../modules/system/laptop/power.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "50%";
  };

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
      width = 1920;
      height = 1200;
      refresh = 59.940;
    };
  };

  # --- State Version ---
  system.stateVersion = "25.05";
}
