{ osConfig, ... }:

{
  imports = [
    ./binds.nix
    ./clipboard.nix
    ./input.nix
    ./layout.nix
    ./outputs.nix
    ./settings.nix
    ./window-rules.nix
  ];

  wayland.windowManager.niri = {
    enable = true;
    # Validates the generated config with the niri that runs it.
    inherit (osConfig.programs.niri) package;
    # The NixOS module installs niri's units, and modules/desktop/wayland.nix
    # owns the portals.
    systemd.enable = false;
    portalPackage = null;
    xwaylandSatellitePackage = null;
  };
}
