{ config, pkgs, ... }:

let
  steamGamescope = pkgs.writeShellApplication {
    name = "steam-gamescope";
    runtimeInputs = [ pkgs.jq ];
    text = ''
      resolution="$(${config.programs.niri.package}/bin/niri msg --json focused-output \
        | jq -er '.modes[.current_mode] | "\(.width) \(.height)"' 2>/dev/null)" \
        || resolution="1920 1080"
      read -r width height <<< "$resolution"

      exec ${pkgs.gamescope}/bin/gamescope \
        -W "$width" -H "$height" \
        -w "$width" -h "$height" \
        --force-windows-fullscreen \
        -- ${config.programs.steam.package}/bin/steam -nobigpicture "$@"
    '';
  };

  steamGamescopeDesktop = pkgs.makeDesktopItem {
    name = "steam-gamescope";
    desktopName = "Steam (Gamescope)";
    comment = "Launch Steam in Gamescope for reliable X11 menus under Niri";
    exec = "${steamGamescope}/bin/steam-gamescope %U";
    icon = "steam";
    terminal = false;
    categories = [ "Game" ];
    mimeTypes = [ "x-scheme-handler/steam" ];
  };
in
{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];

    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    dedicatedServer.openFirewall = false;
  };

  environment.systemPackages = [
    steamGamescope
    steamGamescopeDesktop
  ];
}
