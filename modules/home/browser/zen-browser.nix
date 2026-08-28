{
  inputs,
  osConfig,
  pkgs,
  ...
}:

{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  stylix.targets.zen-browser.profileNames = [ "default" ];

  xdg.configFile."tridactyl/tridactylrc".text = ''
    " Colemak-DH navigation, matching the Helix configuration.
    bind n scrollpx -50 0
    bind e scrollline 5
    bind i scrollline -5
    bind o scrollpx 50 0
    bind / fillcmdline find
    bind k findnext 1
    bind K findnext -1

    " Vertical tabs: down/up move to the next/previous tab.
    bind E tabnext
    bind I tabprev

    " Let Zen handle empty new tabs; Tridactyl otherwise opens its own new-tab page.
    command zennewtab exclaim_quiet ${pkgs.wtype}/bin/wtype -M ctrl -k t -m ctrl
    bind t zennewtab
    bind N back
    bind O forward
    bind u scrollpage 0.5
    bind y scrollpage -0.5
    bind x tabclose
    bind U undo

    bind <Enter> hint
    bind <S-Enter> hint -b

    " Browser extensions cannot invoke Zen's chrome command directly, so replay its shortcut.
    command tabbar exclaim_quiet ${pkgs.wtype}/bin/wtype -M ctrl -k s -m ctrl
    bind <Tab> tabbar
  '';

  programs.zen-browser = {
    enable = true;
    nativeMessagingHosts = [ pkgs.tridactyl-native ];

    policies = {
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      PictureInPicture = {
        Enabled = false;
        Locked = true;
      };
      RequestedLocales = [ "en-US" ];
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      Preferences."zen.view.show-newtab-button-top" = {
        Value = false;
        Status = "locked";
      };

      # Filters for uBlock Origin
      "3rdparty".Extensions."uBlock0@raymondhill.net" = {
        adminSettings = {
          userFilters = ''
            ! YouTube - Hide Shorts
            youtube.com##ytd-rich-shelf-renderer[is-shorts]
            youtube.com##ytd-reel-shelf-renderer
            youtube.com##ytd-guide-entry-renderer:has(a[title="Shorts"])
            youtube.com##ytd-mini-guide-entry-renderer:has(a[title="Shorts"])

            ! YouTube - Hide Recommendations/Related videos
            youtube.com##ytd-watch-next-secondary-results-renderer
            youtube.com###related

            ! YouTube - Hide Comments
            youtube.com##ytd-comments
            youtube.com###comments

            ! YouTube - Hide Homepage recommendations
            youtube.com##ytd-browse[page-subtype="home"] ytd-rich-grid-renderer
          '';
        };
      };
    };

    profiles.default = {
      extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
        ublock-origin
        bitwarden
        tridactyl
      ];

      settings = {
        "browser.download.useDownloadDir" = false;
        "browser.tabs.allow_transparent_browser" = osConfig.my.theme.transparency.enable;
        "browser.tabs.dragDrop.createGroup.enabled" = false;

        # Restore the previous window instead of opening an empty new tab.
        "browser.startup.page" = 3;

        "browser.search.region" = "JP";
        "browser.urlbar.placeholderName.private" = "DuckDuckGo";
        "browser.urlbar.suggest.clipboard" = false;
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.recentsearches" = false;

        "dom.forms.autocomplete.formautofill" = false;
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enable" = true;

        # Keep the browser UI in English while preferring Japanese web content.
        "intl.accept_languages" = "ja-JP, ja, en-US, en";

        "network.trr.mode" = 2;
        "network.trr.uri" = "https://mozilla.cloudflare-dns.com/dns-query";

        "permissions.default.camera" = 2;
        "permissions.default.desktop-notification" = 2;
        "permissions.default.geo" = 2;
        "permissions.default.microphone" = 2;
        "permissions.default.xr" = 2;

        "places.history.enabled" = false;

        "privacy.clearOnShutdown_v2.formdata" = true;
        "privacy.clearSiteData.browsingHistoryAndDownloads" = true;
        "privacy.globalprivacycontrol.was_ever_enabled" = true;
        "privacy.history.custom" = true;
        "privacy.userContext.enabled" = false;

        "zen.tabs.show-newtab-vertical" = false;
        "zen.welcome-screen.seen" = true;
        "zen.workspaces.continue-where-left-off" = true;
        "zen.window-sync.enabled" = true;
        "zen.window-sync.sync-only-pinned-tabs" = true;
        "zen.widget.linux.transparency" = osConfig.my.theme.transparency.enable;
      };

      search = {
        force = true;
        default = "ddg";
        privateDefault = "ddg";
        engines = {
          selfhost = {
            name = "Selfhost";
            urls = [
              { template = "https://{searchTerms}.yawarakatai.com"; }
            ];
            definedAliases = [ "@s" ];
          };
          vault = {
            name = "Vaultwarden";
            urls = [ { template = "https://vault.yawarakatai.com"; } ];
            definedAliases = [ "@vault" ];
          };
          git = {
            name = "Forgejo";
            urls = [ { template = "https://git.yawarakatai.com"; } ];
            definedAliases = [ "@git" ];
          };
          file = {
            name = "FileBrowser";
            urls = [ { template = "https://file.yawarakatai.com"; } ];
            definedAliases = [ "@file" ];
          };
          navidrome = {
            name = "Navidrome";
            urls = [ { template = "https://navidrome.yawarakatai.com"; } ];
            definedAliases = [ "@navi" ];
          };
          kavita = {
            name = "Kavita";
            urls = [ { template = "https://kavita.yawarakatai.com"; } ];
            definedAliases = [ "@kavita" ];
          };
          home = {
            name = "Home Dashboard";
            urls = [ { template = "https://home.yawarakatai.com"; } ];
            definedAliases = [ "@home" ];
          };
        };
      };
    };
  };
}
