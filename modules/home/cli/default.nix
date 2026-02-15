# Core CLI utilities
{ pkgs, ... }:

{
  imports = [
    ./yazi.nix
    ./monitor.nix
  ];

  home.packages = with pkgs; [
    # System info
    neofetch
    htop
    tree

    # Basic tools
    curl
    wget

    # File operations
    bat # cat alternative
    fd # find alternative
    ripgrep # grep alternative
    television # fuzzy finder

    # Other utilities
    tealdeer # tldr (simplified man pages)
    jq # JSON processor
    yq # YAML processor

    # Misc
    tokei # code statistics
    hyperfine # benchmarking tool
    croc # file transfer
    unar # archive unpacker
    zellij # terminal multiplexer
    glow # markdown viewer
  ];
}
