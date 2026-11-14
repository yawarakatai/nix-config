_:

{
  perSystem =
    { pkgs, inputs', ... }:
    {
      # Run from the flake root: the script writes generated host files into the checkout.
      packages.install-host = pkgs.writeShellApplication {
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
    };
}
