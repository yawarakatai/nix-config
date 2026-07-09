{
  inputs,
  lib,
  osConfig,
  ...
}:

let
  theme = osConfig.my.theme;
  ui = osConfig.my.ui;
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    settings = {
      theme = {
        mode = "dark";
        source = "custom";
      };

      shell = {
        font_family = lib.mkForce "JetBrainsMono NL Nerd Font";
        ui_scale = ui.scale;
        niri_overview_type_to_launch_enabled = true;

        panel = {
          transparency_mode = "glass";
          borders = true;
          shadow = true;
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
        background_opacity = lib.mkForce theme.opacity.shellPopups;
        layer = "bottom";
      };

      osd = {
        background_opacity = lib.mkForce theme.opacity.shellPopups;
        position = "top_right";
      };

      bar.main = {
        position = "bottom";
        inherit (ui) scale;
        background_opacity = theme.opacity.shell;
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
