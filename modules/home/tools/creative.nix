{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Game Development
    godot

    # PCB design
    kicad

    # 3D printing
    bambu-studio

    # Video editing
    davinci-resolve
    (writeShellScriptBin "resolve" ''
      export DISPLAY=:0
      export QT_QPA_PLATFORM=xcb
      exec davinci-resolve "$@"
    '')
  ];

  xdg.desktopEntries.davinci-resolve = {
    name = "DaVinci Resolve";
    exec = "env DISPLAY=:0 QT_QPA_PLATFORM=xcb davinci-resolve %U";
    icon = "DV_Resolve";
    terminal = false;
    categories = [ "AudioVideo" "Video" ];
  };
}
