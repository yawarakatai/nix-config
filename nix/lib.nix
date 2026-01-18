{ inputs, ... }:
let
  mkSystem =
    {
      hostname,
      system,
      extraModules ? [ ],
    }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = { inherit inputs; };

      modules = [
        {
          nixpkgs.overlays = import ../overlays;
          networking.hostName = hostname;
          nixpkgs.hostPlatform = system;
          nixpkgs.config.allowUnfree = true;
        }

        ../hosts/${hostname}

        (
          { config, ... }:
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${config.my.user.name} = import ../home/${hostname}/home.nix;
              extraSpecialArgs = { inherit inputs; };
              backupFileExtension = "backup";
            };
          }
        )
      ]
      ++ extraModules;
    };
in
{
  inherit mkSystem;
}
