{
  imports = [
    ../../modules/hardware/gpu/nvidia.nix
    ../../modules/security/gsr-kms-server.nix
    ../../modules/input/mouse/logiops.nix
    ../../modules/input/keyboard/lofree.nix
    ../../modules/services/udev.nix
  ];
}
