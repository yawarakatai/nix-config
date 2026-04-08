{ config, inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.asus-ally-rc71l

    (import ../../modules/system/storage/disko-btrfs.nix {
      device = "/dev/disk/by-id/nvme-WD_BLACK_SN770_1TB_22134E800783";
    })
    ./hardware-configuration.nix
  ];

  jovian = {
    hardware.has.amd.gpu = true;
    steam = {
      enable = true;
      autoStart = true;
      user = config.my.user.name;
      desktopSession = "niri";
    };

    devices.steamdeck = {
      enable = true;
      enableKernelPatches = true;
    };
  };

  boot.kernelModules = [
    "amdgpu"
    "kvm-amd"
  ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  services.handheld-daemon = {
    enable = true;
    user = config.my.user.name;
    ui.enable = true;
  };

  # Tmp on tmpfs for better performance
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "50%";
  };

  # --- My Options ---

  my = {
    system.monitors.primary = {
      name = "eDP-1";
      width = 1920;
      height = 1080;
      refresh = 119.999;
      vrr = true;
    };
  };

  # --- State Version ---
  system.stateVersion = "25.05";
}
