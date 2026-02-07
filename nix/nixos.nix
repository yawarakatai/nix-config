{
  inputs,
  self,
  ...
}:
let
  lib = import ./lib.nix { inherit inputs; };

  commonModules = [
    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    ../modules/system
  ];

  desktopModules = commonModules ++ [
    inputs.stylix.nixosModules.stylix
    inputs.niri.nixosModules.niri
    ../modules/system/desktop
    ../modules/system/display
    ../modules/theme
    ../modules/system/hardware/audio.nix
  ];
in
{
  flake = {
    nixosConfigurations = {
      desuwa = lib.mkSystem {
        hostname = "desuwa";
        system = "x86_64-linux";
        extraModules = desktopModules;
      };

      nanodesu = lib.mkSystem {
        hostname = "nanodesu";
        system = "x86_64-linux";
        extraModules = desktopModules;
      };
    };

    homeConfigurations = {
      "yawarakatai@dayo" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import inputs.nixpkgs {
          system = "aarch64-linux";
          config.allowUnfree = true;
        };
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ../home/dayo/home.nix
        ];
      };
    };

    agenix-rekey = inputs.agenix-rekey.configure {
      userFlake = self;
      nixosConfigurations = self.nixosConfigurations;
    };
  };
}
