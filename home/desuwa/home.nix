{ config, pkgs, vars, inputs, ... }:

{
  # Import common home configuration
  imports = [
    ../common.nix
    ../../modules/home/tools/obs.nix
    ../../modules/home/tools/creative.nix
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
      "--enable-features=UseOzonePlatform,VaapiVideoDecoder,VaapiVideoEncoder,Vulkan,VulkanFromANGLE,DefaultANGLEVulkan"
      "--ozone-platform=wayland"
      "--use-angle=vulkan"
      "--enable-zero-copy"
    ];
  };
}
