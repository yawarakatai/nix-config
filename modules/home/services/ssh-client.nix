_:
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

    settings = {
      "*".setEnv = "TERM=xterm-256color";

      "desuwa" = {
        hostname = "desuwa";
        identityFile = yubikeyIdentities;
        identitiesOnly = true;
        identityAgent = "none";
      };

      "dane" = {
        hostname = "dane.yawarakatai.com";
        identityFile = yubikeyIdentities;
        identitiesOnly = true;
        identityAgent = "none";
      };

      "dayo" = {
        hostname = "dayo.yawarakatai.com";
        identityFile = yubikeyIdentities;
        identitiesOnly = true;
        identityAgent = "none";
      };

      "github.com" = {
        user = "git";
        identityFile = yubikeyIdentities;
        identitiesOnly = true;
        identityAgent = "none";
      };

      "192.168.*" = {
        identityFile = yubikeyIdentities;
        identitiesOnly = true;
        identityAgent = "none";
      };
    };
  };
}
