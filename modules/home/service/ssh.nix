{ ... }:
let
  yubikeyKeys = {
    yubikey_5 = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKoUC9mEqLf9q8geELb89t8I9P+0JBD2fvm51+jwNuu3AAAABHNzaDo= yubikey_5";
    yubikey_5c = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIFwdOpc6zvMiZ0zC/NqC2mzEn0B5hdRz1jD2V76vsclLAAAABHNzaDo= yubikey_5c";
  };

  yubikeyIdentities = [
    "~/.ssh/yubikey_5"
    "~/.ssh/yubikey_5c"
  ];
in
{
  home.file = {
    ".ssh/yubikey_5.pub".text = yubikeyKeys.yubikey_5;
    ".ssh/yubikey_5c.pub".text = yubikeyKeys.yubikey_5c;
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
