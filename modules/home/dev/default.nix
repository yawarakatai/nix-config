{ pkgs, ... }:

{
  home.packages = with pkgs; [
    python3
  ];

  imports = [
    ./direnv.nix
    ./plainix.nix
    ./git.nix
    ./git-identity.nix
    ./lazygit.nix
    ./codex.nix
    ./pi.nix
  ];
}
