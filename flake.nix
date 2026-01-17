{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    treefmt-nix.url = "github:numtide/treefmt-nix";

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
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      agenix-rekey,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          systems,
          ...
        }:
        {
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              nil
              statix
              inputs'.agenix-rekey.packages.default
              pkgs.age-plugin-fido2-hmac
            ];
          };

          treefmt = {
            projectRootFile = "flake.nix";
            programs.nixfmt.enable = true;
          };
        };

      flake =
        let
          commonModules = [
            inputs.agenix.nixosModules.default
            inputs.agenix-rekey.nixosModules.default
            inputs.home-manager.nixosModules.home-manager
            ./modules/system
          ];

          desktopModules = [
            inputs.stylix.nixosModules.stylix
            inputs.niri.nixosModules.niri
            ./modules/system/desktop
            ./modules/system/theme/stylix.nix
            ./modules/system/display/greetd.nix
            ./modules/system/display/wayland.nix
            ./modules/system/hardware/audio.nix
          ];

          mkSystem =
            hostname: extraModules:
            let
              vars = import ./hosts/${hostname}/vars.nix;
            in
            nixpkgs.lib.nixosSystem {
              specialArgs = { inherit vars inputs; };
              modules =
                commonModules
                ++ extraModules
                ++ [
                  {
                    nixpkgs.overlays = import ./overlays;
                    nixpkgs.hostPlatform = vars.system;
                    nixpkgs.config.allowUnfree = true;
                  }

                  ./hosts/${hostname}

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
          nixosConfigurations = {
            desuwa = mkSystem "desuwa" desktopModules;
            nanodesu = mkSystem "nanodesu" desktopModules;
            # server = mkSystem "server" [];
          };

          agenix-rekey = agenix-rekey.configure {
            userFlake = self;
            nixosConfigurations = self.nixosConfigurations;
          };
        };
    };
}
