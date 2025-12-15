{ vars, pkgs, inputs, ... }:
let
  juice_path =
    inputs.juice.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  # Import common home configuration
  imports = [
    ../common.nix
  ];

  # User-specific settings
  home.username = vars.username;
  home.homeDirectory = "/home/${vars.username}";

  # Host-specific packages for nanodesu
  home.packages = with pkgs; [
    thunderbird
    slack
    zoom-us

    libreoffice-qt

    juice_path
  ];

  systemd.user.services.juice-daemon = {
    Unit = {
      Description = "Juice battery history daemon";
      After = [ "default.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${juice_path}/bin/juice daemon";
      # ExecStart = "%h/.cargo/bin/juice daemon";
      Restart = "on-failure";
      RestartSec = 30;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
