{
  inputs,
  lib,
  osConfig,
  ...
}:

let
  theme = osConfig.my.theme;
  ui = osConfig.my.ui;
  wallpaper = osConfig.my.wallpaper;
  inherit (theme) transparency;

  effectiveOpacity = value: if transparency.enable then value else 1.0;
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    settings = {
      accessibility = {
        ui_scale = ui.scale;
      };

      shell = {
        corner_radius_scale = 0;
        niri_overview_type_to_launch_enabled = true;

        panel = {
          transparency_mode = if transparency.enable then "glass" else "solid";
          borders = true;
          shadow = false;
          control_center_placement = "attached";
          wallpaper_placement = "attached";
          session_placement = "attached";
          open_near_click_control_center = true;
        };
      };

      backdrop = {
        enabled = transparency.enable;
        blur_intensity = 0.55;
        tint_intensity = 0.2;
      };

      wallpaper = lib.mkIf (wallpaper.image != null) {
        default.path = "${wallpaper.image}";
      };

      osd.position = "top_right";

      lockscreen.lock_before_suspend = false;

      bar.main = {
        position = "bottom";
        inherit (ui) scale;
        background_opacity = effectiveOpacity 0.65;
        radius = 0;
        margin_edge = 0;
        margin_opposite_edge = 0;
        shadow = false;
        contact_shadow = false;
        auto_hide = true;
        reserve_space = false;
        show_on_workspace_switch = true;
        start = [
          "launcher"
          "workspaces"
        ];
        center = [ "clock" ];
        end = [
          "tray"
          "clipboard"
          "volume"
          "brightness"
          "battery"
        ];
        dead_zone.command = "noctalia msg panel-toggle control-center home";
      };
    };
  };
}
