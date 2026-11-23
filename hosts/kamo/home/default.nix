{
  inputs,
  lib,
  pkgs,
  ...
}:

{
  home.packages = [ pkgs.bottles ];

  imports = [
    ../../../modules/profiles/home/desktop.nix
    ../../../modules/home/services/ura.nix
  ];

  # Gaming Mode also starts graphical-session.target; keep the desktop shell
  # and other Home Manager Wayland services attached only to Niri.
  wayland.systemd.target = "niri.service";

  # Quick desktop switches count as short sessions; the vendor repair then
  # overlays an old Steam bootstrap onto the self-updated client.
  xdg.configFile."inhibit-short-session-tracker".text = "";

  programs.niri = {
    # The touchscreen is attached to the internal panel, not external outputs.
    settings.input.touch.map-to-output = "eDP-1";

    config = lib.mkOptionDefault (
      lib.mkAfter [
        (inputs.niri.lib.kdl.leaf "include" [
          { optional = true; }
          "noctalia.kdl"
        ])
      ]
    );
  };
}
