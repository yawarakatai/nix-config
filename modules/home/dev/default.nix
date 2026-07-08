{ pkgs, ... }:

{
  imports = [
    ./direnv.nix
    ./firn.nix
    ./git.nix
    ./opencode.nix
    ./codex.nix
    ./antigravity.nix
  ];

  home.packages = [ pkgs.herdr ];
}
