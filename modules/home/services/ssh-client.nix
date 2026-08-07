{
  config,
  lib,
  ...
}:
let
  keys = import ../../../secrets/keys.nix;
  identities = config.my.ssh.identityFiles;
in
{
  options.my.ssh.identityFiles = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [
      "~/.ssh/yubikey_5"
      "~/.ssh/yubikey_5c"
    ];
    description = "SSH identity files used for hosts managed by this configuration.";
  };

  config = {
    home.file = {
      ".ssh/yubikey_5.pub".text = keys.ssh.yubikey-5;
      ".ssh/yubikey_5c.pub".text = keys.ssh.yubikey-5c;
    };

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings = {
        "*".setEnv = "TERM=xterm-256color";

        "desuwa" = {
          hostname = "desuwa.yawarakatai.com";
          identityFile = identities;
          identitiesOnly = true;
          identityAgent = "none";
        };

        "dane" = {
          hostname = "dane.yawarakatai.com";
          identityFile = identities;
          identitiesOnly = true;
          identityAgent = "none";
        };

        "kamo" = {
          hostname = "kamo.yawarakatai.com";
          identityFile = identities;
          identitiesOnly = true;
          identityAgent = "none";
        };

        "github.com" = {
          user = "git";
          identityFile = identities;
          identitiesOnly = true;
          identityAgent = "none";
        };

        "192.168.*" = {
          identityFile = identities;
          identitiesOnly = true;
          identityAgent = "none";
        };
      };
    };
  };
}
