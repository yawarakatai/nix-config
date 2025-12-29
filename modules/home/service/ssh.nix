{ ... }:
let
  keys = import ../../../secrets/keys.nix;

  yubikeyIdentities = [
    "~/.ssh/yubikey_5"
    "~/.ssh/yubikey_5c"
  ];
in
{
  home.file = {
    ".ssh/yubikey_5.pub".text = keys.yubikey.yubikey_5;
    ".ssh/yubikey_5c.pub".text = keys.yubikey.yubikey_5c;
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        setEnv = {
          TERM = "xterm-256color";
        };
      };

      "github.com" = {
        user = "git";
        identityFile = yubikeyIdentities;
        identitiesOnly = true;
      };

      "192.168.*" = {
        identityFile = yubikeyIdentities;
        identitiesOnly = true;
      };
    };
  };
}
