{
  config,
  inputs,
  pkgs,
  ...
}:

let
  madoriLib = import ../../lib/madori.nix;
in
{
  imports = [
    inputs.nixos-hardware.nixosModules.asus-ally-rc71l

    (import ../../features/storage/disko-btrfs.nix {
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
      desktopSession = "gnome";
    };

    devices.steamdeck.enable = false;
  };

  boot.kernelModules = [
    "amdgpu"
    "kvm-amd"
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  services.xserver.videoDrivers = [ "amdgpu" ];

  services.handheld-daemon = {
    enable = true;
    user = config.my.user.name;
    ui.enable = false;
  };

  # Tmp on tmpfs for better performance
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "25%";
  };

  # --- My Options ---

  my = {
    system.monitors.primary = (import ../../displays).ally-builtin;
  };

  services.madori = {
    enable = true;
    package = inputs.madori.packages.x86_64-linux.default;

    monitors.ally = madoriLib.mkMonitor "eDP-1" 1.0;

    rules = [
      (madoriLib.only "ally")
      (madoriLib.virtual 1920 1080 60)
    ];
  };

  # --- State Version ---
  system.stateVersion = "25.05";
}
