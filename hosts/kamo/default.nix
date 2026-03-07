{ inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.asus-ally-rc71l

    ./hardware-configuration.nix
    ./disko.nix
    ../../modules/system/gaming # Steam
  ];

  boot.kernelModules = [
    "amdgpu"
    "kvm-amd"
  ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  services.handheld-daemon.enable = true;

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
      refresh = 119.880;
      scale = 1.0;
      vrr = true;
    };
  };

  # --- State Version ---
  # State version - DO NOT CHANGE after initial install
  system.stateVersion = "25.05";
}
