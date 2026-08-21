{ lib, osConfig, ... }:

{
  programs.niri.settings.outputs = lib.mapAttrs (_name: output: {
    inherit (output) enable;
    mode = {
      inherit (output) width height refresh;
    };
    variable-refresh-rate = if output.vrr then "on-demand" else false;
    inherit (output) scale position;
    transform.rotation = output.transform;
  }) osConfig.my.display.outputs;
}
