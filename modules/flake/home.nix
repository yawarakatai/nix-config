{
  inputs,
  self,
  ...
}:

let
  # Explicit overrides require --impure; pure evaluation keeps reproducible defaults.
  portableUsername = builtins.getEnv "PORTABLE_USERNAME";
  portableHome = builtins.getEnv "PORTABLE_HOME";
  username = if portableUsername == "" then "yawarakatai" else portableUsername;
  homeDirectory = if portableHome == "" then "/home/${username}" else portableHome;

  mkPortableHome =
    system:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      extraSpecialArgs = {
        inherit inputs self username;
      };

      modules = [
        ../profiles/home/portable.nix
        {
          home = {
            inherit username homeDirectory;
            stateVersion = "25.05";
            enableNixpkgsReleaseCheck = false;
          };
        }
      ];
    };
in
{
  flake.homeConfigurations = {
    portable = mkPortableHome "x86_64-linux";
    portable-aarch64 = mkPortableHome "aarch64-linux";
  };
}
