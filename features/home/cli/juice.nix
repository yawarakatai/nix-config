{
  inputs,
  pkgs,
  ...
}:
let
  juice-path = inputs.juice.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  # Add juice package
  home.packages = [ juice-path ];

  # Juice battery history daemon service
  systemd.user.services.juice-daemon = {
    Unit = {
      Description = "Juice battery history daemon";
      After = [ "default.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${juice-path}/bin/juice daemon";
      # ExecStart = "%h/.cargo/bin/juice daemon";
      Restart = "on-failure";
      RestartSec = 30;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
