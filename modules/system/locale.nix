{ pkgs, vars, ... }:

{
  # Time zone
  time.timeZone = vars.timezone;

  # Locale settings
  i18n = {
    defaultLocale = vars.locale;

    extraLocaleSettings = {
      LC_ADDRESS = vars.locale;
      LC_IDENTIFICATION = vars.locale;
      LC_MEASUREMENT = vars.locale;
      LC_MONETARY = vars.locale;
      LC_NAME = vars.locale;
      LC_NUMERIC = vars.locale;
      LC_PAPER = vars.locale;
      LC_TELEPHONE = vars.locale;
      LC_TIME = vars.locale;
    };

    # Japanese locale support
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "ja_JP.UTF-8/UTF-8"
    ];
  };

  # Console configuration
  console = {
    font = "Lat2-Terminus16";
    keyMap = vars.keyboardLayout;
  };

  # Japanese input method - fcitx5 with mozc
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      ];

      waylandFrontend = true;
    };
  };
}
