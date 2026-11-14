{ osConfig, pkgs, ... }:
let
  token = osConfig.age.secrets.github-token-ro.path;
  # Inject the token per invocation instead of exporting it to every process.
  gh = pkgs.writeShellScriptBin "gh" ''
    GH_TOKEN="$(< ${token})" exec ${pkgs.gh}/bin/gh "$@"
  '';
in
{
  programs.gh = {
    enable = true;
    package = gh;
    # Lets HTTPS fetches of private repos authenticate with the read-only token.
    gitCredentialHelper.enable = true;
    settings.git_protocol = "ssh";
  };
}
