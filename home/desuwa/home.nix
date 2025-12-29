{ vars, ... }:

{
  imports = [
    ../common.nix
    ../../modules/home/media/obs.nix
    ../../modules/home/creative
    ../../modules/home/dev/claude-code.nix
    # ../../modules/home/desktop/gnome.nix
    # ../../modules/home/terminal/ghostty.nix
    ../../modules/home/browser/zen-browser.nix
  ];

  home.username = vars.username;
  home.homeDirectory = "/home/${vars.username}";

  # programs.brave = {
  #   enable = true;
  #   commandLineArgs = [
  #     "--enable-features=UseOzonePlatform,VaapiVideoDecoder,VaapiVideoEncoder"
  #     "--ozone-platform=wayland"
  #     "--enable-zero-copy"
  #   ];
  # };
}
