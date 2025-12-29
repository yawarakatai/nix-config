# Nix configuration
{ vars, ... }:

{
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "root" vars.username ];
    };

    # gc = {
    #   automatic = true;
    #   dates = "weekly";
    #   options = "--delete-older-than 30d";
    # };

    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      max-jobs = auto
    '';
  };

  nixpkgs.config.allowUnfree = true;
}
