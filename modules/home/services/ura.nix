{ inputs, pkgs, ... }:

{
  imports = [
    inputs.ura.homeManagerModules.default
  ];

  services.ura = {
    enable = true;

    bind = "0.0.0.0:8765";

    defaultLoop = true;

    logLevel = "ura=info";

    ytDlpPackage = inputs.nixpkgs-ytdlp.legacyPackages.${pkgs.stdenv.hostPlatform.system}.yt-dlp;
  };

  # Temporary: yt-dlp 2026.10.26 prefers tv_samsung, whose stream URLs return
  # HTTP 403. Remove once a yt-dlp update plays YouTube without this.
  xdg.configFile."yt-dlp/config".text = ''
    --extractor-args youtube:player_client=default,-tv_samsung
  '';
}
