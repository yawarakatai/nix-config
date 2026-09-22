{ config, ... }:

{
  imports = [
    ../../modules/hardware/gpu/nvidia.nix
    ../../modules/input/mouse/logiops.nix
    ../../modules/input/keyboard/lofree.nix
  ];

  # Keep the factory-overclocked RTX 3080 near its best gaming efficiency point.
  systemd.services.nvidia-power-limit = {
    description = "Set NVIDIA GPU power limit";
    after = [ "systemd-modules-load.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${config.hardware.nvidia.package.bin}/bin/nvidia-smi --id=0 --power-limit=320";
      RemainAfterExit = true;
      Restart = "on-failure";
      RestartSec = "2s";
    };
  };
}
