{ ... }:
let
  yubikeyIdentities = [
    "~/.ssh/yubikey_5"
    "~/.ssh/yubikey_5c"
  ];
in
{
  programs.ssh = {
    enable = true;

    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        setEnv = { TERM = "xterm-256color"; };
      };

      "github.com" = {
        user = "git";
        identityFile = yubikeyIdentities;
        identitiesOnly = true;
      };

      "192.168.*" = {
        # forwardAgent = true;
        identityFile = yubikeyIdentities;
        identitiesOnly = true;
      };
    };
  };
}
