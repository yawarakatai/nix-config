{
  inputs,
  osConfig,
  pkgs,
  ...
}:
let
  juice-path = inputs.juice.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  # Import common home configuration
  imports = [
    ../../../modules/home/profiles/desktop.nix
  ];

  # User-specific settings
  home.username = osConfig.my.user.name;
  home.homeDirectory = "/home/${osConfig.my.user.name}";

  # Host-specific packages for nanodesu
  home.packages = with pkgs; [
    thunderbird
    slack
    zoom-us

    libreoffice-qt

    juice-path
  ];

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

  # State version - DO NOT CHANGE after initial install
  home.stateVersion = "25.05";
}
