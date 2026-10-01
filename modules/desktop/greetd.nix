{ config, pkgs, ... }:

{
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
      user = "greeter";
    };
  };

  security.pam.services.greetd.enableGnomeKeyring = false;

  environment.etc."greetd/sessions/tty.desktop".text = ''
    [Desktop Entry]
    Name=TTY
    Comment=Drop to shell
    Exec=${pkgs.bashInteractive}/bin/bash
    Type=Application
  '';
}
