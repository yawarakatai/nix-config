{
  inputs,
  lib,
  osConfig,
  ...
}:

let
  inherit (inputs.niri.lib.kdl) leaf plain;
  transparencyEnabled = osConfig.my.theme.transparency.enable;
  transparencyRules = lib.optionals transparencyEnabled [
    # Keep blur for transient backdrop layers rather than persistent windows.
    (plain "blur" [
      (leaf "passes" 1)
      (leaf "offset" 16.0)
    ])
    (plain "layer-rule" [
      (leaf "match" { namespace = "^noctalia-backdrop"; })
      (leaf "place-within-backdrop" true)
    ])
  ];
in
{
  programs.niri = {
    config = lib.mkOptionDefault (
      lib.mkAfter (
        [
          (leaf "include" [
            { optional = true; }
            "noctalia.kdl"
          ])
        ]
        ++ transparencyRules
      )
    );

    settings.debug.honor-xdg-activation-with-invalid-serial = [ ];
  };
}
