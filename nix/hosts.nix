{ inputs, self, ... }:
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
    ../modules/system/desktop
    ../modules/system/theme/stylix.nix
    ../modules/system/display
    ../modules/system/hardware/audio.nix
  ];

  mkSystem =
    hostname: extraModules:
    let
      # パス調整
      vars = import ../hosts/${hostname}/vars.nix;
    in
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = { inherit vars inputs; };
      modules =
        commonModules
        ++ extraModules
        ++ [
          {
            nixpkgs.overlays = import ../overlays;
            nixpkgs.hostPlatform = vars.system;
            nixpkgs.config.allowUnfree = true;
          }
          ../hosts/${hostname}
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${vars.username} = import ../home/${hostname}/home.nix;
              extraSpecialArgs = { inherit vars inputs; };
              backupFileExtension = "backup";
            };
          }
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
