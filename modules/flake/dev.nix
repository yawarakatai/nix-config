_:

{
  perSystem =
    { pkgs, inputs', ... }:
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

      treefmt = {
        projectRootFile = "flake.nix";
        programs.nixfmt = {
          enable = true;
          excludes = [ "hosts/*/generated/hardware-configuration.nix" ];
        };
      };
    };
}
