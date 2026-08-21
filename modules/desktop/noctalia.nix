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
      storage = {
        key_source = "file";
        key_file = "/run/agenix/noctalia-storage-key";
      };

      theme = {
        mode = "dark";
        source = "custom";
      };

      accessibility = {
        ui_scale = ui.scale;
      };

      shell = {
        font_family = lib.mkForce theme.fonts.monospace.name;
        niri_overview_type_to_launch_enabled = true;

        panel = {
          transparency_mode = if transparency.enable then "glass" else "solid";
          borders = true;
          shadow = true;
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

      notification = {
        background_opacity = lib.mkForce (effectiveOpacity theme.opacity.shellPopups);
        layer = "bottom";
      };

      osd = {
        background_opacity = lib.mkForce (effectiveOpacity theme.opacity.shellPopups);
        position = "top_right";
      };

      bar.main = {
        position = "bottom";
        inherit (ui) scale;
        background_opacity = effectiveOpacity theme.opacity.shell;
        radius = theme.rounding;
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
