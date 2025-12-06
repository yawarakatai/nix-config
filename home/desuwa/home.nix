{ pkgs, vars, ... }:

{
  # Import common home configuration
  imports = [
    ../common.nix
    ../../modules/home/tools/obs.nix
    ../../modules/home/tools/creative.nix
    ../../modules/home/tools/claude-code.nix
    # ../../modules/home/desktop/gnome.nix
    # ../../modules/home/terminal/ghostty.nix
  ];

  # User-specific settings
  home.username = vars.username;
  home.homeDirectory = "/home/${vars.username}";

  home.packages = with pkgs; [
    # Video Edition
    # kdePackages.kdenlive
  ];

  programs.brave = {
    enable = true;
    commandLineArgs = [
      "--enable-features=UseOzonePlatform,VaapiVideoDecoder,VaapiVideoEncoder"
      "--ozone-platform=wayland"
      "--enable-zero-copy"
    ];
  };
}
