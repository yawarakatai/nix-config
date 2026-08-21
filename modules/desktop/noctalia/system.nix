{ lib, ... }:

let
  inherit (lib) mkOption types;
in
{
  options.my = {
    wallpaper = {
      image = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Shared wallpaper image used by Noctalia on all displays.";
      };

      fallbackColor = mkOption {
        type = types.str;
        default = "#0b0f14";
        description = "Solid background color used when no wallpaper is configured.";
      };
    };

    ui.scale = mkOption {
      type = types.float;
      default = 1.0;
      description = "Global Noctalia shell scale preference for this device.";
    };
  };
}
