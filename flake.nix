{
  description = "NixOS configuration with flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae = {
      url = "github:vicinaehq/vicinae";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }@inputs:
    let
      # Helper function to create system configurations
      mkSystem = hostname:
        let
          vars = import ./hosts/${hostname}/vars.nix;
        in
        nixpkgs.lib.nixosSystem {
          system = vars.system;
          specialArgs = { inherit vars inputs; };
          modules = [
            # Host-specific configuration (imports its own modules)
            ./hosts/${hostname}/configuration.nix
            ./hosts/${hostname}/hardware-configuration.nix

            # Home Manager integration
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;

                users.${vars.username} = import ./home/${hostname}/home.nix;
                extraSpecialArgs = { inherit vars inputs; };
                backupFileExtension = "backup";
              };
            }
          ];
        };
    in
    {
      # System configurations
      nixosConfigurations = {
        desuwa = mkSystem "desuwa";
        nanodesu = mkSystem "nanodesu";
      };

      # Development shell for editing configurations
      devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
        buildInputs = with nixpkgs.legacyPackages.x86_64-linux; [
          nil # Nix LSP
          nixpkgs-fmt # Nix formatter
          statix # Nix linter
        ];

        shellHook = ''
          echo "NixOS configuration development environment"
          echo "Available tools: nil, nixpkgs-fmt, statix"
        '';
      };
    };
}
