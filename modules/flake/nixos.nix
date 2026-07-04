{
  inputs,
  self,
  ...
}:
let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  nixosModules = self.modules.nixos;

  mkHost =
    hostname: profileModule:
    {
      extraModules ? [ ],
      system ? "x86_64-linux",
    }:
    nixosSystem {
      inherit system;
      specialArgs = { inherit inputs self; };
      modules = [
        {
          networking.hostName = hostname;
          nixpkgs.hostPlatform = system;
          nixpkgs.config.allowUnfree = true;
          system.stateVersion = "25.05";
        }
        ../../hosts/${hostname}
        inputs.home-manager.nixosModules.home-manager
        (
          { config, ... }:
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${config.my.user.name} = import ../../hosts/${hostname}/home;
              extraSpecialArgs = { inherit inputs self; };
              backupFileExtension = "backup";
            };
          }
        )
        profileModule
      ]
      ++ extraModules;
    };

in
{
  flake = {
    nixosConfigurations = {
      desuwa = mkHost "desuwa" nixosModules.profileDesktopNiri { };

      nanodesu = mkHost "nanodesu" nixosModules.profileLaptop {
        extraModules = [ inputs.lanzaboote.nixosModules.lanzaboote ];
      };

      dane = mkHost "dane" nixosModules.profileServer {
        system = "aarch64-linux";
        extraModules = [ inputs.nixos-rock5t.nixosModules.rock5t ];
      };
    };

    agenix-rekey = inputs.agenix-rekey.configure {
      userFlake = self;
      inherit (self) nixosConfigurations;
    };
  };
}
