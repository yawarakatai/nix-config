# Core CLI utilities
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # File operations
    # eza # ls alternative
    # bat # cat alternative
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

    zellij
  ];
}
