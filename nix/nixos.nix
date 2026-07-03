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
      inputs.niri.nixosModules.niri
      ../features/core/i18n.nix
      ../features/desktop/wayland.nix
      ../features/theme
      ../features/hardware/audio.nix
      ../features/hardware/bluetooth.nix
      ../features/display/greetd.nix
      ../features/niri/system.nix
    ];

    laptop = commonDesktop ++ [
      ../features/laptop/power.nix
      ../features/laptop/lid.nix
    ];

    server = secret ++ [
      ../features/core/locale.nix
      ../features/server
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
          system.stateVersion = "25.05";
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
      desuwa = mkHost "desuwa" profiles.commonDesktop { };

      nanodesu = mkHost "nanodesu" profiles.laptop {
        extraModules = [ inputs.lanzaboote.nixosModules.lanzaboote ];
      };

      dane = mkHost "dane" profiles.server {
        system = "aarch64-linux";
        extraModules = [ inputs.nixos-rock5t.nixosModules.rock5t ];
      };
    };

    agenix-rekey = inputs.agenix-rekey.configure {
      userFlake = self;
      nixosConfigurations = self.nixosConfigurations;
    };
  };
}
