{ pkgs, ... }:

{
  home.packages = with pkgs; [
    easyeffects
    lsp-plugins
    calf
    zam-plugins
    mda_lv2
  ];

  xdg.configFile =
    let
      dolbyIrs = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/JackHack96/EasyEffects-Presets/master/irs/Dolby%20ATMOS%20((128K%20MP3))%201.Default.irs";
        name = "dolby-atmos.irs";
        sha256 = "f45b751d92c54c188645f87fc0988667d5acb4cb6f76d5febb79556372425403";
      };
      presetJson = builtins.readFile ./ally-speakers-preset.json;
    in
    {
      "easyeffects/irs/Dolby ATMOS ((128K MP3)) 1.Default.irs".source = dolbyIrs;
      "easyeffects/output/ROG Ally Speakers.json".text = presetJson;
      "autostart/easyeffects.desktop".text = ''
        [Desktop Entry]
        Name=EasyEffects
        Exec=easyeffects --gapplication-service
        Terminal=false
        Type=Application
        X-GNOME-Autostart-enabled=true
      '';
    };
}
