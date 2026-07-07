_:

{
  perSystem =
    {
      pkgs,
      inputs',
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          just

          nixd
          nixfmt
          statix
          deadnix

          inputs'.agenix-rekey.packages.default
          pkgs.age-plugin-fido2-hmac
        ];
      };

      treefmt = {
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = true;
      };
    };
}
