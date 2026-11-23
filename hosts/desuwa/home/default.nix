{ pkgs, ... }:

{
  home.packages = with pkgs; [
    godot
    # See hosts/kamo/home/default.nix: the warning alert hides under onboarding.
    (bottles.override { removeWarningPopup = true; })
    orca-slicer
  ];

  imports = [
    ../../../modules/profiles/home/desktop.nix
    ../../../modules/home/creative/pixelorama.nix
    ../../../modules/home/services/ura.nix
  ];
}
