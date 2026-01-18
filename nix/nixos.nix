{
  inputs,
  self,
  ...
}:
let
  commonModules = [
    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    ../modules/system
  ];

  desktopModules = [
    inputs.stylix.nixosModules.stylix
    inputs.niri.nixosModules.niri
    ../modules/theme
    ../modules/system/desktop
    ../modules/system/display
    ../modules/system/hardware/audio.nix
  ];

  mkSystem =
    hostname: extraModules:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules =
        commonModules
        ++ extraModules
        ++ [
          {
            nixpkgs.overlays = import ../overlays;
            nixpkgs.config.allowUnfree = true;
          }
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
        ];
    };
in
{
  flake = {
    nixosConfigurations = {
      desuwa = mkSystem "desuwa" desktopModules;
      nanodesu = mkSystem "nanodesu" desktopModules;
    };

    agenix-rekey = inputs.agenix-rekey.configure {
      userFlake = self;
      nixosConfigurations = self.nixosConfigurations;
    };
  };
}
