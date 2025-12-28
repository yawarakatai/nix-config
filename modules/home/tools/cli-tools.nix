{ config, pkgs, ... }:

{
  # Collection module for common CLI tools
  # Note: This module groups multiple related utilities together
  # Individual apps get their own modules (e.g., helix.nix, firefox.nix)
  # but small CLI tools are collected here for convenience

  # Install CLI tools
  home.packages = with pkgs; [
    # File operations
    # eza # ls alternative
    # bat # cat alternative
    fd # find alternative
    ripgrep # grep alternative

    # System monitoring
    bottom # htop/top alternative
    duf # df alternative
    dust # du alternative
    procs # ps alternative

    # Other utilities
    tealdeer # tldr (simplified man pages)
    jq # JSON processor
    yq # YAML processor

    # Network tools
    bandwhich # network monitor

    # Misc
    tokei # code statistics
    hyperfine # benchmarking tool
    croc # file transfer

    zellij
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

      # Colors - will be configured by stylix
    };
  };
}
