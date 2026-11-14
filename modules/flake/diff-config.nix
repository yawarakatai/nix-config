_:

{
  perSystem =
    { pkgs, ... }:
    {
      # Run from the checkout: it compares the working tree against a git revision.
      packages.diff-config = pkgs.writeShellApplication {
        name = "diff-config";
        runtimeInputs = [
          pkgs.git
          pkgs.jq
          pkgs.nix-diff
        ];
        text = builtins.readFile ./diff-config.sh;
      };
    };
}
