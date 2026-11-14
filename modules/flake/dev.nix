{ self, ... }:

{
  perSystem =
    {
      lib,
      pkgs,
      inputs',
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nixd
          nixfmt
          statix
          deadnix
          nix-unit

          inputs'.agenix-rekey.packages.default
          pkgs.age-plugin-fido2-hmac
        ];
      };

      checks = {
        lint =
          pkgs.runCommand "lint"
            {
              nativeBuildInputs = [
                pkgs.statix
                pkgs.deadnix
              ];
            }
            ''
              cd ${self}
              statix check -i 'hosts/*/generated/hardware-configuration.nix'
              deadnix --fail --exclude hosts/*/generated/hardware-configuration.nix
              touch $out
            '';

        # Instantiating drvPaths catches evaluation errors without building every Home Manager package.
        home-configurations = pkgs.writeText "home-configurations" (
          lib.concatMapStringsSep "\n" (
            home: builtins.unsafeDiscardStringContext home.activationPackage.drvPath
          ) (lib.attrValues self.homeConfigurations)
        );
      };

      treefmt = {
        projectRootFile = "flake.nix";
        programs.nixfmt = {
          enable = true;
          excludes = [ "hosts/*/generated/hardware-configuration.nix" ];
        };
      };
    };
}
