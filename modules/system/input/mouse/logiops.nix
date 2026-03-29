{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ logiops ];

  environment.etc."logid.cfg".source = ./logid.cfg;

  systemd.services.logiops = {
    description = "Logitech Configuration Daemon";
    wants = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.logiops}/bin/logid";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
