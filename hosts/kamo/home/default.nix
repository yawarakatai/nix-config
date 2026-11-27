{ pkgs, ... }:

{
  # The nixpkgs "Unsupported Environment" alert opens first and the first-run
  # onboarding dialog then covers it, leaving the window unresponsive.
  home.packages = [ (pkgs.bottles.override { removeWarningPopup = true; }) ];

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

  wayland.windowManager.niri = {
    # The touchscreen is attached to the internal panel, not external outputs.
    settings.input.touch.map-to-output = "eDP-1";

    # Last, so that what Noctalia writes there overrides the settings above.
    extraConfig = ''include "noctalia.kdl" optional=true'';
  };
}
