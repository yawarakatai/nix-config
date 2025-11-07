{ config, pkgs, vars, ... }:

{
  programs.firefox = {
    enable = true;

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableFirefoxScreenshots = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
      DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
      SearchBar = "unified"; # alternative: "separate"
    };

    # profiles.default = {
    #   settings = {
    #     "browser.startup.homepage" = "about:blank";
    #     "browser.newtabpage.enabled" = false;
    #     "general.smoothScroll" = true;
    #     "layers.acceleration.force-enabled" = true; # Wayland GPU acceleration
    #   };
    # };
  };
}
