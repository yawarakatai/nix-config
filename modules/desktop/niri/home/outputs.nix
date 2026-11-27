{ lib, osConfig, ... }:

let
  modeString =
    output: "${toString output.width}x${toString output.height}@${toString output.refresh}";
  transformString = rotation: if rotation == 0 then "normal" else toString rotation;

  outputNode =
    name: output:
    {
      _args = [ name ];
    }
    // (
      if !output.enable then
        { off = { }; }
      else
        {
          mode =
            if output.customMode then
              {
                _args = [ (modeString output) ];
                _props.custom = true;
              }
            else
              modeString output;
          inherit (output) scale;
          position._props = output.position;
          transform = transformString output.transform;
        }
        // lib.optionalAttrs output.primary { focus-at-startup = { }; }
        // lib.optionalAttrs output.vrr { variable-refresh-rate._props.on-demand = true; }
    );
in
{
  wayland.windowManager.niri.settings._children = lib.mapAttrsToList (name: output: {
    output = outputNode name output;
  }) osConfig.my.display.outputs;
}
