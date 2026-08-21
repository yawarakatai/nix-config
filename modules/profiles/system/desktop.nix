{ inputs, ... }:

{
  imports = [
    ./secret.nix
    inputs.stylix.nixosModules.stylix
    ../../core/i18n.nix
    ../../desktop/wayland.nix
    ../../theme
    ../../hardware/audio.nix
    ../../hardware/bluetooth.nix
    ../../desktop/greetd.nix
  ];
}
