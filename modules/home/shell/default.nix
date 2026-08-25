{ ... }:

{
  imports = [
    ./zsh.nix
    ./starship.nix
  ];

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
