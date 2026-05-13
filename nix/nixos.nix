{
  inputs,
  self,
  ...
}:
let
  inherit (inputs.nixpkgs.lib) nixosSystem;

  profiles = rec {
    base = [
      inputs.disko.nixosModules.disko
      ../lib/options.nix
      ../features
      ../features/core
      ../features/storage
      ../features/service/tailscale.nix
      ../features/input/keyboard/kanata.nix
    ];

    secret = base ++ [
      inputs.agenix.nixosModules.default
      inputs.agenix-rekey.nixosModules.default
      ../features/security
      ../features/service/openssh.nix
    ];

    commonDesktop = secret ++ [
      inputs.stylix.nixosModules.stylix
      inputs.madori.nixosModules.default
      ../features/core/i18n.nix
      ../features/desktop/common.nix
      ../features/desktop/wayland.nix
      ../features/theme
      ../features/hardware/audio.nix
    ];

    niriDesktop = commonDesktop ++ [
      inputs.niri.nixosModules.niri
      ../features/display/greetd.nix
      ../features/niri/system.nix
    ];

    gnomeDesktop = commonDesktop ++ [
      ../features/gnome/system.nix
    ];

    laptop = niriDesktop ++ [
      ../features/laptop/power.nix
      ../features/laptop/lid.nix
    ];

    handheld = gnomeDesktop ++ [
      inputs.jovian-nixos.nixosModules.default
    ];

    server = secret ++ [
      ../features/core/locale.nix
      ../features/server
      ../features/service/tailscale-serve.nix
    ];
  };

  mkHost =
    hostname: profileModules:
    {
      extraModules ? [ ],
      system ? "x86_64-linux",
    }:
    nixosSystem {
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
      ++ profileModules
      ++ extraModules;
    };

in
{
  flake = {
    nixosConfigurations = {
      desuwa = mkHost "desuwa" profiles.niriDesktop { };

      nanodesu = mkHost "nanodesu" profiles.laptop {
        extraModules = [ inputs.lanzaboote.nixosModules.lanzaboote ];
      };

      nanoda = mkHost "nanoda" profiles.laptop { };

      kamo = mkHost "kamo" profiles.handheld { };

      dayo = mkHost "dayo" profiles.server {
        system = "aarch64-linux";
      };
    };

    agenix-rekey = inputs.agenix-rekey.configure {
      userFlake = self;
      nixosConfigurations = self.nixosConfigurations;
    };
  };
}
