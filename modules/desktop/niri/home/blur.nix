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
    (plain "blur" [
      (leaf "passes" 5)
      (leaf "offset" 8.0)
      (leaf "noise" 0.01)
      (leaf "saturation" 1.05)
    ])
    (plain "window-rule" [
      (plain "background-effect" [
        (leaf "blur" true)
        (leaf "xray" true)
        (leaf "noise" 0.01)
        (leaf "saturation" 1.05)
      ])
    ])
    (plain "window-rule" [
      (leaf "match" { app-id = "^(com\\.mitchellh\\.ghostty|Alacritty)$"; })
      (plain "background-effect" [
        (leaf "blur" true)
        (leaf "xray" false)
        (leaf "noise" 0.01)
        (leaf "saturation" 1.05)
      ])
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
