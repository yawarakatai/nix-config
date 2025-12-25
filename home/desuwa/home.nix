{ pkgs, vars, ... }:

{
  imports = [
    ../common.nix
    ../../modules/home/tools/obs.nix
    ../../modules/home/tools/creative.nix
    ../../modules/home/tools/claude-code.nix
    # ../../modules/home/desktop/gnome.nix
    # ../../modules/home/terminal/ghostty.nix
    ../../modules/home/browser/zen-browser.nix
  ];

  home.username = vars.username;
  home.homeDirectory = "/home/${vars.username}";

  home.packages = with pkgs; [
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

  programs.brave = {
    enable = true;
    commandLineArgs = [
      "--enable-features=UseOzonePlatform,VaapiVideoDecoder,VaapiVideoEncoder"
      "--ozone-platform=wayland"
      "--enable-zero-copy"
    ];
  };
}
