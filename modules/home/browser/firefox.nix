{ ... }:
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
      FirefoxHome = {
        TopSites = true;
        Locked = true;
        SponsoredTopSites = false;
        Pocket = false;
        SponsoredPocket = false;
        Highlights = false;
      };
    };

    profiles.default = {
      id = 0;
      isDefault = true;
      settings = {
        # --- Appearance ---
        "ui.systemUsesDarkTheme" = 1;

        # --- New Tab Page: Show only Firefox logo and search bar ---
        "browser.newtabpage.enabled" = true;
        "browser.topsites.contile.enabled" = false;
        "browser.newtabpage.activity-stream.default.sites" = "";
        "browser.newtabpage.activity-stream.feeds.topsites" = true;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
        "browser.newtabpage.activity-stream.feeds.snippets" = false;
        "browser.newtabpage.activity-stream.showSearch" = true;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.showWeather" = false;

        "browser.newtabpage.pinned" = builtins.toJSON [
          {
            url = "https://search.nixos.org";
            label = "nixpkgs";
          }
        ];

        # --- Startup ---
        "browser.startup.homepage" = "about:home";
        "browser.startup.page" = 1;

        # --- Search: Enable suggestions in URL bar ---
        "browser.search.suggest.enabled" = true;
        "browser.urlbar.suggest.searches" = true;
        "browser.urlbar.suggest.history" = true;
        "browser.urlbar.suggest.bookmark" = true;
        "browser.urlbar.suggest.openpage" = true;

        # --- Privacy & Security ---
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "dom.security.https_only_mode" = true;
        "media.peerconnection.ice.default_address_only" = true; # Prevent WebRTC IP leak
        "extensions.pocket.enabled" = false;
        "browser.formfill.enable" = false;

        # --- Telemetry (belt-and-suspenders with policies) ---
        "toolkit.telemetry.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "app.shield.optoutstudies.enabled" = false;
        "browser.tabs.crashReporting.sendReport" = false;

        # --- Performance (Wayland / Niri) ---
        "general.smoothScroll" = true;
        "layers.acceleration.force-enabled" = true;
        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true; # VA-API hardware video decoding

        # --- Misc ---
        "browser.sessionstore.resume_from_crash" = true;
        "browser.download.manager.retention" = 0;
        "browser.aboutConfig.showWarning" = false;
      };
    };
  };

  # Ensure Firefox runs natively on Wayland (avoid blurry XWayland fallback)
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };
}
