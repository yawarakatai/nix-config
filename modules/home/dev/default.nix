{ pkgs, ... }:

{
  home.packages = with pkgs; [
    python3
  ];

  imports = [
    ./direnv.nix
    ./nix.nix
    ./plainix.nix
    ./git.nix
    ./git-identity.nix
    ./lazygit.nix
    ./pi.nix
    ./claude-code.nix
  ];
}
