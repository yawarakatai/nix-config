{
  inputs,
  lib,
  osConfig,
  ...
}:

let
  theme = osConfig.my.theme;
  colors = osConfig.lib.stylix.colors.withHashtag;
  noctaliaPalette = {
    primary = colors.base0D;
    onPrimary = colors.base00;
    secondary = colors.base0C;
    onSecondary = colors.base00;
    tertiary = colors.base0E;
    onTertiary = colors.base00;
    error = colors.base08;
    onError = colors.base00;
    surface = colors.base00;
    onSurface = colors.base05;
    surfaceVariant = colors.base01;
    onSurfaceVariant = colors.base04;
    outline = colors.base03;
    shadow = colors.base00;
    hover = colors.base02;
    onHover = colors.base05;

    terminal = {
      foreground = colors.base05;
      background = colors.base00;
      cursor = colors.base05;
      cursorText = colors.base00;
      selectionFg = colors.base05;
      selectionBg = colors.base02;
      normal = {
        black = colors.base00;
        red = colors.base08;
        green = colors.base0B;
        yellow = colors.base0A;
        blue = colors.base0D;
        magenta = colors.base0E;
        cyan = colors.base0C;
        white = colors.base05;
      };
      bright = {
        black = colors.base03;
        red = colors.base08;
        green = colors.base0B;
        yellow = colors.base0A;
        blue = colors.base0D;
        magenta = colors.base0E;
        cyan = colors.base0C;
        white = colors.base07;
      };
    };
  };
in
{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.waybar.enable = lib.mkForce false;
  services.mako.enable = lib.mkForce false;
  programs.vicinae.enable = lib.mkForce false;

  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    customPalettes.stylix.dark = noctaliaPalette;

    settings = {
      theme = {
        mode = "dark";
        source = "custom";
        custom_palette = "stylix";
      };

      shell = {
        font_family = "JetBrainsMono NL Nerd Font";
        ui_scale = 1.2;
        niri_overview_type_to_launch_enabled = true;

        panel = {
          transparency_mode = "glass";
          borders = true;
          shadow = true;
          launcher_placement = "centered";
          clipboard_placement = "centered";
          control_center_placement = "attached";
          wallpaper_placement = "attached";
          session_placement = "attached";
          open_near_click_control_center = true;
        };
      };

      backdrop = {
        enabled = true;
        blur_intensity = 0.55;
        tint_intensity = 0.2;
      };

      notification = {
        background_opacity = theme.opacity.shellPopups;
        layer = "top";
      };

      osd = {
        background_opacity = theme.opacity.shellPopups;
        position = "top_right";
      };

      bar.main = {
        position = theme.bar.position;
        thickness = theme.bar.thickness;
        scale = 1.1;
        background_opacity = theme.opacity.shell;
        radius = theme.rounding;
        margin_ends = theme.bar.marginEnds;
        margin_edge = 0;
        margin_opposite_edge = 0;
        padding = theme.bar.padding;
        shadow = false;
        contact_shadow = false;
        auto_hide = true;
        reserve_space = false;
        show_on_workspace_switch = true;
        start = [ "workspaces" ];
        center = [ "clock" ];
        end = [
          "tray"
        ];
        dead_zone.command = "noctalia msg panel-toggle control-center home";
      };
    };
  };
}
