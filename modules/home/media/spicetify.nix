{ inputs, ... }:

{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  programs.spicetify = {
    enable = true;
    # Stylix automatically themes Spotify
  };
}
