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

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae = {
      url = "github:vicinaehq/vicinae";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    juice.url = "github:yawarakatai/juice";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }@inputs:
    let
      # Helper function to create system configurations
      mkSystem = hostname:
        let
          vars = import ./hosts/${hostname}/vars.nix;
        in
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit vars inputs; };
          modules = [
            { nixpkgs.overlays = import ./overlays; }
            { nixpkgs.hostPlatform = vars.system; }

            # Stylix theming
            inputs.stylix.nixosModules.stylix
            ./modules/system/theme/stylix.nix

            # Niri compositor
            inputs.niri.nixosModules.niri

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

      # Helper for supporting multiple systems
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      # System configurations
      nixosConfigurations = {
        desuwa = mkSystem "desuwa";
        nanodesu = mkSystem "nanodesu";
      };

      # Development shell for editing configurations
      devShells = forAllSystems
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          {
            default = pkgs.mkShell {
              buildInputs = with pkgs; [
                nil # Nix LSP
                nixpkgs-fmt # Nix formatter
                statix # Nix linter
              ];

              shellHook = ''
                echo "NixOS configuration development environment"
                echo "Available tools: nil, nixpkgs-fmt, statix"
              '';
            };
          }
        );
    };
}
