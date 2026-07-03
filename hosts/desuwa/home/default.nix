{ pkgs, self, ... }:

let
  discord-wrapped = pkgs.symlinkJoin {
    name = "discord-wrapped";
    paths = [ pkgs.discord ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/discord \
        --add-flags "--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer" \
        --add-flags "--ozone-platform=wayland"
    '';
  };
in
{
  imports = [
    self.modules.homeManager.profiles.desktopNiri
    ../../../features/home/creative
  ];

  home.packages = with pkgs; [
    discord-wrapped
  ];
}
