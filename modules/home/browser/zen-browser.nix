{ inputs, pkgs, ... }:

{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  programs.zen-browser = {
    enable = true;
    suppressXdgMigrationWarning = true;

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
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
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
      # extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
      #   ublock-origin
      #   privacy-badger
      #   proton-pass
      #   bitwarden
      # ];

      settings = {
        browser = {
          search.region = "JP";

          urlbar = {
            placeholderName.private = "DuckDuckGo";
            suggest = {
              clipboard = false;
              engines = false;
              history = false;
              openpage = false;
              recentsearches = false;
            };
          };
        };

        dom = {
          forms.autocomplete.formautofill = false;
          security.https_only_mode = true;
          security.https_only_mode_ever_enable = true;
        };

        network.trr = {
          mode = 2;
          uri = "https://mozilla.cloudflare-dns.com/dns-query";
        };

        permissions.default = {
          camera = 2;
          desktop-notification = 2;
          geo = 2;
          microphone = 2;
          xr = 2;
        };

        privacy = {
          clearOnShutdown_v2.formdata = true;
          globalprivacycontrol.was_ever_enabled = true;
          history.custom = true;
          userContext.enabled = false;
        };

        zen = {
          welcome-screen.seen = true;
          workspaces.continue-where-left-off = true;
          window-sync.enable = true;
          window-sync.sync-only-pinned-tabs = true;
        };
      };

      search = {
        force = true;
        default = "brave";
        engines = {
          brave = {
            name = "Brave Search";
            urls = [
              {
                template = "https://search.brave.com/search?q={searchTerms}";
                params = [
                  {
                    name = "query";
                    value = "searchTerms";
                  }
                ];
              }
            ];
            definedAliases = [ "@brave" ];
          };
          mynixos = {
            name = "My NixOS";
            urls = [
              {
                template = "https://mynixos.com/search?q={searchTerms}";
                params = [
                  {
                    name = "query";
                    value = "searchTerms";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share//icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@nx" ]; # Keep in mind that aliases defined here only work if they start with "@"
          };
        };
      };
    };
  };
}
