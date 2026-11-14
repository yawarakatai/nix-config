{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
      user = "greeter";
    };
  };

  # greetd's PAM stack delegates to `login`, so the keyring must be disabled there.
  security.pam.services.login.enableGnomeKeyring = lib.mkForce false;

  environment.etc."greetd/sessions/tty.desktop".text = ''
    [Desktop Entry]
    Name=TTY
    Comment=Drop to shell
    Exec=${pkgs.bashInteractive}/bin/bash
    Type=Application
  '';
}
