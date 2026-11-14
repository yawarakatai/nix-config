_:

{
  perSystem =
    { pkgs, inputs', ... }:
    {
      # Both run from the checkout and act on it.
      packages = {
        # Writes generated host files into the checkout.
        install-host = pkgs.writeShellApplication {
          name = "install-host";
          runtimeInputs = [
            pkgs.coreutils
            pkgs.git
            pkgs.gnutar
            pkgs.openssh
            pkgs.nixos-anywhere
            inputs'.agenix-rekey.packages.default
            pkgs.age-plugin-fido2-hmac
          ];
          text = builtins.readFile ./install-host.sh;
        };

        # Compares the working tree against a git revision.
        diff-config = pkgs.writeShellApplication {
          name = "diff-config";
          runtimeInputs = [
            pkgs.git
            pkgs.jq
            pkgs.nix-diff
          ];
          text = builtins.readFile ./diff-config.sh;
        };
      };
    };
}
