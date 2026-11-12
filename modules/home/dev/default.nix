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
    ./lazygit.nix
  ];
}
