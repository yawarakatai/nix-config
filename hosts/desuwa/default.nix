{ pkgs, ... }:

let
  disk = ./disk.nix;
in
{
  imports = [
    (import ../../modules/storage/disko-btrfs.nix {
      inherit (disk) device;
    })
    ./hardware-configuration.nix

    # Hardware-specific modules
    ../../modules/hardware/gpu/nvidia.nix # NVIDIA RTX 3080
    ../../modules/security/gsr-kms-server.nix
    ../../modules/input/mouse/logiops.nix # Logitech mouse
    ../../modules/input/keyboard/lofree.nix # Lofree Flow keyboard
    ../../modules/services/udev.nix

    ../../modules/services
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    binfmt.emulatedSystems = [ "aarch64-linux" ];

    # Tmp on tmpfs for better performance
    tmp = {
      useTmpfs = true;
      tmpfsSize = "50%";
    };
  };

  # --- Application and Service Settings ---;
  environment.sessionVariables = {
    __GL_SHADER_DISK_CACHE = "1";
    __GL_THREADED_OPTIMIZATION = "1";
  };

  # Restrict kanata to physical keyboard only (avoid intercepting logid Virtual Input)
  services.kanata.keyboards.internal.devices = [
    "/dev/input/by-id/usb-CX_2.4G_Wireless_Receiver-event-kbd"
  ];

  # --- My Options ---
  my = {
    system.monitors.primary = {
      name = "DP-3";
      width = 3840;
      height = 2160;
      refresh = 144.000;
      scale = 1.0;
      vrr = true;
    };

    ui = {
      scale = 1.25;

      bar = {
        position = "bottom";
        thicknessRatio = 0.016;
        minThickness = 34;
        maxThickness = 44;
        padding = 10;
        marginEndsRatio = 0.333;
        maxMarginEnds = 1920;
      };
    };
  };
}
