{
  inputs,
  pkgs,
  ...
}:

let
  packages = inputs.hanas.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.packages = [ packages.hanas ];

  xdg.configFile."hanas/config.toml".text = ''
    [engine]
    url = "http://127.0.0.1:10101"
    style_id = 1878365378
    speed = 1.0
  '';

  systemd.user.services.aivisspeech-engine = {
    Unit = {
      Description = "AivisSpeech Engine";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${packages.aivisspeech-engine}/bin/aivisspeech-engine --host 127.0.0.1 --port 10101 --no-use_gpu --disable_sentry";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  systemd.user.services.hanas = {
    Unit = {
      Description = "hanas text-to-speech daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "aivisspeech-engine.service" ];
      Wants = [ "aivisspeech-engine.service" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${packages.hanas}/bin/hanas daemon";
      Restart = "on-failure";
      RestartSec = 2;
      UMask = "0077";
      RuntimeDirectory = "hanas";
      RuntimeDirectoryMode = "0700";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
