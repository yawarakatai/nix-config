{ inputs, ... }:

{
  imports = [
    ./secret.nix
    ../../security/github-token.nix
    ../../security/yubikey.nix
    ../../security/yubikey-ssh-keys.nix
    inputs.stylix.nixosModules.stylix
    ../../core/i18n.nix
    ../../desktop/wayland.nix
    ../../desktop/noctalia/system.nix
    ../../theme
    ../../hardware/audio.nix
    ../../hardware/bluetooth.nix
    ../../desktop/greetd.nix
    ../../services/networkmanager.nix
    ../../services/syncthing.nix
    ../../services/tailscale.nix
    ../../input/keyboard/kanata.nix
  ];
}
