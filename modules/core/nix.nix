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
      accept-flake-config = true;
      # Any trusted key can sign any store path, so each cache is trusted only
      # by the modules that need it; nixpkgs already adds cache.nixos.org.
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
