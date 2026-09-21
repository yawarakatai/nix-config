{ pkgs, ... }:

let
  logiops = pkgs.logiops.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or [ ]) ++ [
      ./patches/logiops-mx-master-3s-bluetooth-thumbwheel.patch
    ];
  });
in
{
  environment.systemPackages = [ logiops ];

  environment.etc."logid.cfg".source = ./logid.cfg;

  systemd.services.logiops = {
    description = "Logitech Configuration Daemon";
    wants = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${logiops}/bin/logid";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
