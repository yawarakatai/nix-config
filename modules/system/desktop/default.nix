{
  inputs,
  pkgs,
  ...
}:

{
  services.gvfs.enable = true;
  programs.dconf.enable = true;

  programs.niri = {
    enable = true;
    package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;
  };

  programs.xwayland.enable = true;
}
