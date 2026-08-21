{ config, ... }:

let
  stylixColors = config.lib.stylix.colors.withHashtag;
in
{
  stylix.targets.gtk.extraCss = ''
    @define-color accent_bg_color ${stylixColors.base0A};
    @define-color accent_fg_color ${stylixColors.base00};
    @define-color accent_color ${stylixColors.base0A};
    @define-color theme_selected_bg_color ${stylixColors.base0A};
    @define-color theme_selected_fg_color ${stylixColors.base00};
    @define-color theme_unfocused_selected_bg_color ${stylixColors.base0A};
    @define-color theme_unfocused_selected_fg_color ${stylixColors.base00};
  '';
}
