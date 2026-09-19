{
  inputs,
  lib,
  osConfig,
  ...
}:

let
  inherit (inputs.niri.lib.kdl) flag leaf node;
  outputs = osConfig.my.display.outputs;
  requiresRawConfig = output: output.customMode || output.maxBpc != null;
  standardOutputs = lib.filterAttrs (_name: output: !requiresRawConfig output) outputs;
  rawOutputs = lib.filterAttrs (_name: requiresRawConfig) outputs;

  modeString =
    output: "${toString output.width}x${toString output.height}@${toString output.refresh}";
  transformString = rotation: if rotation == 0 then "normal" else toString rotation;

  renderRawOutput =
    name: output:
    node "output" name (
      if !output.enable then
        [ (flag "off") ]
      else
        lib.flatten [
          (leaf "mode" (
            if output.customMode then
              [
                { custom = true; }
                (modeString output)
              ]
            else
              modeString output
          ))
          (lib.optional (output.maxBpc != null) (leaf "max-bpc" output.maxBpc))
          (leaf "scale" output.scale)
          (leaf "position" output.position)
          (leaf "transform" (transformString output.transform))
          (lib.optional output.vrr (leaf "variable-refresh-rate" { on-demand = true; }))
        ]
    );
in
{
  programs.niri = {
    settings.outputs = lib.mapAttrs (_name: output: {
      inherit (output) enable;
      mode = {
        inherit (output) width height refresh;
      };
      variable-refresh-rate = if output.vrr then "on-demand" else false;
      inherit (output) scale position;
      transform.rotation = output.transform;
    }) standardOutputs;

    # niri-flake does not yet expose custom modes or max-bpc in its typed output settings.
    config = lib.mkIf (rawOutputs != { }) (
      lib.mkOptionDefault (lib.mkBefore (lib.mapAttrsToList renderRawOutput rawOutputs))
    );
  };
}
