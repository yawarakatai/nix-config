{ ... }:

{
  perSystem =
    {
      config,
      pkgs,
      inputs',
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
}
