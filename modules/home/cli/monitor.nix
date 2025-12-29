# System monitoring CLI tools
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # System monitoring
    duf # df alternative
    dust # du alternative
    procs # ps alternative

    # Network tools
    bandwhich # network monitor
  ];

  # bottom configuration
  programs.bottom = {
    enable = true;

    settings = {
      flags = {
        color = "default";
        mem_as_value = true;
        tree = true;
      };
    };
  };
}
