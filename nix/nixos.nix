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

        ../hosts/${hostname}
        inputs.home-manager.nixosModules.home-manager
        (
          { config, ... }:
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${config.my.user.name} = import ../hosts/${hostname}/home;
              extraSpecialArgs = { inherit inputs; };
              backupFileExtension = "backup";
            };
          }
        )
      ]
      ++ extraModules;
    };

  baseModules = [
    inputs.disko.nixosModules.disko
    ../lib/options.nix
    ../modules/system
    ../modules/system/core
    ../modules/system/storage
    ../modules/system/service/tailscale.nix
    ../modules/system/input/keyboard/kanata.nix
  ];

  secretModules = [
    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default
    ../modules/system/security
    ../modules/system/service/openssh.nix
  ];

  desktopModules = [
    inputs.stylix.nixosModules.stylix
    inputs.niri.nixosModules.niri
    ../modules/system/core/i18n.nix
    ../modules/system/desktop
    ../modules/system/display
    ../modules/theme
    ../modules/system/hardware/audio.nix
  ];

  serverModules = [
    ../modules/system/core/locale.nix
    ../modules/system/server
    ../modules/system/service/tailscale-serve.nix
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

      # desuno = mkSystem {
      #   hostname = "desuno";
      #   system = "x86_64-linux";
      #   extraModules = baseModules ++ secretModules ++ desktopModules;
      # };

      nanodesu = mkSystem {
        hostname = "nanodesu";
        system = "x86_64-linux";
        extraModules =
          baseModules ++ secretModules ++ desktopModules ++ [ inputs.lanzaboote.nixosModules.lanzaboote ];
      };

      # kamo = mkSystem {
      #   hostname = "kamo";
      #   system = "x86_64-linux";
      #   extraModules =
      #     baseModules ++ secretModules ++ desktopModules ++ [ inputs.jovian-nixos.nixosModules.default ];
      # };

      dayo = mkSystem {
        hostname = "dayo";
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
