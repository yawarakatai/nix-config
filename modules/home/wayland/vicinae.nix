{ theme, inputs, ... }:
let
  vicinaeTheme = theme: ''
    [meta]
    version = 1
    name = "${theme.name}"
    description = "Custom theme: ${theme.name}"
    variant = "dark"

    [colors.core]
    background = "${theme.colorScheme.base00}"
    foreground = "${theme.colorScheme.base05}"
    secondary_background = "${theme.colorScheme.base01}"
    border = "${theme.colorScheme.base03}"
    accent = "${theme.colorScheme.base0D}"

    [colors.accents]
    blue = "${theme.colorScheme.base0D}"
    green = "${theme.colorScheme.base0B}"
    magenta = "${theme.colorScheme.base0E}"
    orange = "${theme.colorScheme.base09}"
    purple = "${theme.colorScheme.base0E}"
    red = "${theme.colorScheme.base08}"
    yellow = "${theme.colorScheme.base0A}"
    cyan = "${theme.colorScheme.base0C}"
  '';
in
{
  imports = [ inputs.vicinae.homeManagerModules.default ];

  home.file.".local/share/vicinae/themes/${theme.name}.toml".text = vicinaeTheme theme;

  services.vicinae = {
    enable = true;

    systemd = {
      enable = true; # default: false
      autoStart = true; # default: false
      environment = {
        USE_LAYER_SHELL = 1;
      };
    };

    settings = {
      # Favicon service
      faviconService = "twenty"; # twenty | google | none

      # Font
      font.size = theme.font.size;

      # Behavior
      popToRootOnClose = false;
      rootSearch.searchFiles = true;

      # Theme
      theme.name = theme.name; # or "vicinae-light"

      # Window settings
      window = {
        csd = true;
        opacity = theme.opacity.launcher;
        rounding = theme.rounding;
      };
    };


    # # Installing (vicinae) extensions declaratively
    # extensions = [
    #   (inputs.vicinae.mkVicinaeExtension.${pkgs.system} {
    #     inherit pkgs;
    #     name = "extension-name";
    #     src = pkgs.fetchFromGitHub {
    #       # You can also specify different sources other than github
    #       owner = "repo-owner";
    #       repo = "repo-name";
    #       rev = "v1.0"; # If the extension has no releases use the latest commit hash
    #       # You can get the sha256 by rebuilding once and then copying the output hash from the error message
    #       sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    #     }; # If the extension is in a subdirectory you can add ` + "/subdir"` between the brace and the semicolon here
    #   })
    # ];
  };
}
