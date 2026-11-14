{
  inputs,
  self,
  ...
}:
let
  inherit (inputs.nixpkgs.lib) filterAttrs nixosSystem;
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
          nixpkgs = {
            hostPlatform = system;
            config.allowUnfree = true;
          };
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

      dane = mkHost "dane" nixosModules.profileMinimal {
        system = "aarch64-linux";
        extraModules = [ nixosModules.profileSecret ];
      };

      nanodesu = mkHost "nanodesu" nixosModules.profileLaptop { };

      kamo = mkHost "kamo" nixosModules.profileDesktopNiri { };
    };

    agenix-rekey = inputs.agenix-rekey.configure {
      userFlake = self;
      # Hosts get their key from install-host, which rekeys them once it exists.
      nixosConfigurations = filterAttrs (
        host: _: builtins.pathExists ../../hosts/${host}/generated/ssh_host_ed25519_key.pub
      ) self.nixosConfigurations;
    };
  };
}
