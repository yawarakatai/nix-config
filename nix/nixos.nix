{
  inputs,
  self,
  ...
}:
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

        inputs.home-manager.nixosModules.home-manager
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

  mkHome =
    {
      username,
      hostname,
      system,
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      extraSpecialArgs = { inherit inputs; };
      modules = [
        ../home/${hostname}/home.nix
      ];
    };

  baseModules = [
    ../modules/system/core/networking.nix
    ../modules/system/core/nix.nix
    ../modules/system/storage/zram.nix
    ../modules/system/service/tailscale.nix
  ];

  secretModules = [
    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default
    ../modules/system/core/users.nix
    ../modules/system/security
    ../modules/system/service/openssh.nix
  ];

  desktopModules = [
    inputs.stylix.nixosModules.stylix
    inputs.niri.nixosModules.niri
    ../modules/system/core/boot.nix
    ../modules/system/desktop
    ../modules/system/display
    ../modules/theme
    ../modules/system/hardware/audio.nix
    ../modules/system/storage/btrfs.nix
  ];

  serverModules = [
    ../modules/system/server
    # ../modules/system/service/tailscale-serve.nix
  ];

in
{
  flake = {
    nixosConfigurations = {
      desuwa = mkSystem {
        hostname = "desuwa";
        system = "x86_64-linux";
        extraModules = baseModules ++ secretModules ++ desktopModules;
      };

      nanodesu = mkSystem {
        hostname = "nanodesu";
        system = "x86_64-linux";
        extraModules = baseModules ++ secretModules ++ desktopModules;
      };

      daze = mkSystem {
        hostname = "daze";
        system = "aarch64-linux";
        extraModules = baseModules ++ secretModules ++ serverModules;
      };
    };

    agenix-rekey = inputs.agenix-rekey.configure {
      userFlake = self;
      nixosConfigurations = self.nixosConfigurations;
    };
  };
}
