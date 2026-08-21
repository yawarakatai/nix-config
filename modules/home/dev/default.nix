{ pkgs, ... }:

{
  home.packages = with pkgs; [
    python3
  ];

  imports = [
    ./direnv.nix
    ./firn.nix
    ./git.nix
    ./git-identity.nix
    ./lazygit.nix
    ./codex.nix
    ./pi.nix
  ];
}
