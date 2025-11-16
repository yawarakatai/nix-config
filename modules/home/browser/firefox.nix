{ config, pkgs, vars, ... }:

{
  programs.firefox = {
    enable = true;

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DontCheckDefaultBrowser = true;

      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      PasswordManagerEnabled = false;

      DisplayBookmarksToolbar = "never";
      DisplayMenuBar = "default-off";
      SearchBar = "unified";

      ExtensionSettings = {
        "*" = {
          installation_mode = "blocked";
        };
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };

    profiles.default = {
      id = 0;
      isDefault = true;
      settings = {
        "ui.systemUsesDarkTheme" = 1;
        "browser.startup.homepage" = "about:home";
        "browser.newtabpage.enabled" = true;

        "general.smoothScroll" = true;
        "layers.acceleration.force-enabled" = true;

        "browser.formfill.enable" = false;
        "browser.search.suggest.enabled" = true;
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.bookmark" = false;
        "browser.urlbar.suggest.openpage" = false;

        "extensions.pocket.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

        "browser.startup.page" = 1;
        "browser.sessionstore.resume_from_crash" = true;

        "browser.download.manager.retention" = 0;
      };
    };
  };
}
