{ lib, pkgs, ... }:

{
  services = {
    gvfs.enable = true;

    # Home Manager owns SSH authentication.
    gnome.gcr-ssh-agent.enable = false;

    # Logins that skip the password (fingerprint, autologin) or a password change
    # leave the login keyring locked and prompting; apps fall back to their own storage.
    gnome.gnome-keyring.enable = lib.mkForce false;
  };

  programs.dconf.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    # The nixpkgs niri module's niri-portals.conf would replace this file for
    # Niri sessions, preferring the GNOME portal and GNOME Keyring's Secret portal.
    config.niri = lib.mkForce { };
    config.common = {
      default = [
        "gtk"
        "gnome"
      ];

      "org.freedesktop.impl.portal.Access" = "gtk";
      "org.freedesktop.impl.portal.Notification" = "gtk";

      "org.freedesktop.impl.portal.ScreenCast" = "gnome";
      "org.freedesktop.impl.portal.Screenshot" = "gnome";
    };
  };
}
