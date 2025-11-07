{
  description = "NixOS configuration with flakes - yawarakatai";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, niri, sops-nix, ... }@inputs:
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
            # Host-specific configuration
            ./hosts/${hostname}/configuration.nix
            ./hosts/${hostname}/hardware-configuration.nix

            # System modules
            ./modules/system/boot.nix
            ./modules/system/networking.nix
            ./modules/system/locale.nix
            ./modules/system/audio.nix
            ./modules/system/zram.nix
            ./modules/system/storage.nix
            ./modules/system/yubikey.nix
            ./modules/system/rebuild-helper.nix
            ./modules/system/wayland.nix
            ./modules/system/niri-override.nix

            # niri Wayland compositor
            niri.nixosModules.niri

            # sops-nix for secrets management
            sops-nix.nixosModules.sops

            # Home Manager integration
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${vars.username} = import ./home/${vars.username}/home.nix;
                extraSpecialArgs = { inherit vars inputs; };
              };
            }
          ] ++ nixpkgs.lib.optionals vars.hasNvidia [
            ./modules/system/nvidia.nix
          ];
        };
    in
    {
      # System configurations
      nixosConfigurations = {
        desuwa = mkSystem "desuwa";
        # Future: nanodesu = mkSystem "nanodesu";
      };

      # Development shell for editing configurations
      devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
        buildInputs = with nixpkgs.legacyPackages.x86_64-linux; [
          nil # Nix LSP
          nixpkgs-fmt # Nix formatter
          statix # Nix linter
          age # Encryption tool for sops
          sops # Secret management
        ];

        shellHook = ''
          echo "NixOS configuration development environment"
          echo "Available tools: nil, nixpkgs-fmt, statix, age, sops"
        '';
      };
    };
}
