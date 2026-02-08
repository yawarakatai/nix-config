# Core CLI utilities
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Basic tools
    curl
    wget

    # File operations
    bat # cat alternative
    fd # find alternative
    ripgrep # grep alternative

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
  ];
}
