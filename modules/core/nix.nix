{ username, ... }:

{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # Deduplicate on the weekly timer instead of adding I/O to every store import.
      auto-optimise-store = false;
      # Any trusted key can sign any store path, so hosts use only
      # cache.nixos.org, which nixpkgs already adds (asserted in tests.nix).
    };

    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      max-jobs = auto
      cores = 0
    '';
  };

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 4d --keep 5";
    };
    flake = "/home/${username}/.config/nix-config";
  };
}
