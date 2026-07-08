{ pkgs, ... }:

let
  wallpaper = pkgs.fetchurl {
    url = "https://i.redd.it/mg5w8i3gkstg1.jpeg";
    hash = "sha256-02EacG9i2c4puqQ5VRVPTBZmZDInA8pBC8QG9IMJEn8=";
  };
in
{
  stylix.image = wallpaper;

  home-manager.users.yawarakatai = {
    home.file.".cache/noctalia/wallpapers.json".text = builtins.toJSON {
      defaultWallpaper = "${wallpaper}";
      wallpapers = { };
    };
  };
}
