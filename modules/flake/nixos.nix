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
      username ? "yawarakatai",
    }:
    nixosSystem {
      inherit system;
      specialArgs = { inherit inputs self username; };
      modules = [
        {
          networking.hostName = hostname;
          nixpkgs.hostPlatform = system;
          nixpkgs.config.allowUnfree = true;
          system.stateVersion = "25.05";
        }
        ../../hosts/${hostname}
        inputs.home-manager.nixosModules.home-manager
        (_: {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${username} = import ../../hosts/${hostname}/home;
            extraSpecialArgs = { inherit inputs self username; };
            backupFileExtension = "backup";
          };
        })
        profileModule
      ]
      ++ extraModules;
    };

in
{
  flake = {
    nixosConfigurations = {
      desuwa = mkHost "desuwa" nixosModules.profileDesktopNiri { };

      nanodesu = mkHost "nanodesu" nixosModules.profileLaptop { };

      dane = mkHost "dane" nixosModules.profileServer {
        system = "aarch64-linux";
      };

      kamo = mkHost "kamo" nixosModules.profileDesktopNiri { };
    };

    agenix-rekey = inputs.agenix-rekey.configure {
      userFlake = self;
      inherit (self) nixosConfigurations;
    };
  };
}
