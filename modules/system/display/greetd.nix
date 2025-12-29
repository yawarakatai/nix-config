{ pkgs, ... }:

{
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions /etc/greetd/sessions:/run/current-system/sw/share/wayland-sessions";
      user = "greeter";
    };
  };

  # TTY session for greeter fallback
  environment.etc."greetd/sessions/tty.desktop".text = ''
    [Desktop Entry]
    Name=TTY
    Comment=Drop to shell
    Exec=${pkgs.bashInteractive}/bin/bash
    Type=Application
  '';

  # Niri session
  environment.etc."greetd/sessions/niri.desktop".text = ''
    [Desktop Entry]
    Name=niri
    Comment=A scrollable-tiling Wayland compositor
    Exec=niri-session
    Type=Application
  '';
}
