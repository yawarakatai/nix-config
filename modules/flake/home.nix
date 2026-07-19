{
  inputs,
  self,
  ...
}:

let
  username = "yawarakatai";

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
        self.modules.homeManager.profiles.portable
        {
          home = {
            inherit username;
            homeDirectory = "/home/${username}";
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
