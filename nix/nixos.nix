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

  highPerformanceModules = desktopModules ++ [
    inputs.chaotic.nixosModules.default
  ];
in
{
  flake = {
    nixosConfigurations = {
      desuwa = lib.mkSystem {
        hostname = "desuwa";
        system = "x86_64-linux";
        extraModules = highPerformanceModules;
      };

      nanodesu = lib.mkSystem {
        hostname = "nanodesu";
        system = "x86_64-linux";
        extraModules = desktopModules;
      };
    };

    agenix-rekey = inputs.agenix-rekey.configure {
      userFlake = self;
      nixosConfigurations = self.nixosConfigurations;
    };
  };
}
