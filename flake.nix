{
  description = "NixOS configuration with flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
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

    vicinae.url = "github:vicinaehq/vicinae";

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    juice.url = "github:yawarakatai/juice";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-hardware,
      agenix,
      agenix-rekey,
      ...
    }@inputs:
    let
      # Helper function to create system configurations
      mkSystem =
        hostname:
        let
          vars = import ./hosts/${hostname}/vars.nix;
        in
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit vars inputs; };
          modules = [
            {
              nixpkgs.overlays = import ./overlays;
              nixpkgs.hostPlatform = vars.system;
              nixpkgs.config.allowUnfree = true;
            }

            # Agenix for secrets
            agenix.nixosModules.default
            agenix-rekey.nixosModules.default

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
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      # System configurations
      nixosConfigurations = {
        desuwa = mkSystem "desuwa";
        nanodesu = mkSystem "nanodesu";
      };

      # Expose agenix-rekey configuration
      agenix-rekey = agenix-rekey.configure {
        userFlake = self;
        nixosConfigurations = self.nixosConfigurations;
      };

      # Development shell for editing configurations
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ agenix-rekey.overlays.default ];
          };
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              nil # Nix LSP
              nixfmt-tree # Nix formatter
              statix # Nix linter
              pkgs.agenix-rekey # agenix CLI with rekey support
              age-plugin-fido2-hmac # YubiKey FIDO2 plugin
            ];

            shellHook = ''
              echo "NixOS configuration development environment"
              echo "Available tools: nil, treefmt (nixfmt), statix, agenix"
            '';
          };
        }
      );
    };
}
