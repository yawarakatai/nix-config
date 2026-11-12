{
  inputs,
  lib,
  self,
  ...
}:

let
  # Explicit overrides require --impure; pure evaluation keeps reproducible defaults.
  portableUsername = builtins.getEnv "PORTABLE_USERNAME";
  portableHome = builtins.getEnv "PORTABLE_HOME";
  username = if portableUsername == "" then "yawarakatai" else portableUsername;
  homeDirectory = if portableHome == "" then "/home/${username}" else portableHome;

  # Optional aspects layered on the minimal profile, e.g. PORTABLE_FEATURES=ghostty,ssh.
  portableFeatures = {
    ghostty = ../home/terminal/ghostty-portable.nix;
    ssh = ../home/services/ssh-client.nix;
    shell = ../home/shell/portable.nix;
    agents = ../home/dev/agents.nix;
    git-identity = ../home/dev/git-identity.nix;
  };
  selectedFeatures = lib.filter (name: name != "") (
    lib.splitString "," (builtins.getEnv "PORTABLE_FEATURES")
  );
  featureModule =
    name:
    portableFeatures.${name}
      or (throw "Unknown PORTABLE_FEATURES entry '${name}'; available: ${lib.concatStringsSep ", " (lib.attrNames portableFeatures)}");

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
      ]
      ++ map featureModule selectedFeatures;
    };
in
{
  flake.homeConfigurations = {
    portable = mkPortableHome "x86_64-linux";
    portable-aarch64 = mkPortableHome "aarch64-linux";
  };
}
