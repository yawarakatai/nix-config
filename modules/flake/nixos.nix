{
  inputs,
  self,
  ...
}:
let
  inherit (inputs.nixpkgs.lib) filterAttrs nixosSystem;

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
      desuwa = mkHost "desuwa" ../profiles/system/desktop-niri.nix { };

      dayo = mkHost "dayo" ../profiles/system/minimal.nix {
        system = "aarch64-linux";
        extraModules = [ ../profiles/system/secret.nix ];
      };

      nanodesu = mkHost "nanodesu" ../profiles/system/laptop.nix { };

      kamo = mkHost "kamo" ../profiles/system/desktop-niri.nix { };
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
