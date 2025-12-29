# Creative tools for game development, 3D modeling, PCB design, and video editing
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Game Development
    godot

    # 3D modeling
    blender

    # PCB design
    kicad

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
