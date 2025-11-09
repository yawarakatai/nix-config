{ config, pkgs, vars, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions /etc/profiles/per-user/${vars.username}/share/wayland-sessions";
        user = "greeter";
      };
    };
  };
}
