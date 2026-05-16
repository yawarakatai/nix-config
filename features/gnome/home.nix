{
  config,
  pkgs,
  ...
}:

{
  dconf = {
    enable = true;
    settings = {
      "org/gnome/mutter" = {
        experimental-features = [ "variable-refresh-rate" ];
      };

      "org/gnome/desktop/peripherals/touchpad" = {
        tap-to-click = true;
        natural-scroll = true;
      };

      "org/gnome/desktop/a11y/applications" = {
        screen-keyboard-enabled = true;
      };

      "org/gnome/desktop/a11y/keyboard" = {
        enable = true;
      };

      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-type = "nothing";
        sleep-inactive-battery-type = "suspend";
      };

      "org/gnome/desktop/wm/preferences" = {
        num-workspaces = 5;
      };

      "org/gnome/shell/overrides" = {
        dynamic-workspaces = false;
      };

      "org/gnome/desktop/interface" = {
        enable-hot-corners = false;
      };
    };
  };

  home.packages = with pkgs; [
    gnome-tweaks
  ];
}
