{ config, ... }:
let
  keys = import ../../../secrets/keys.nix;
in
{
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  users.users.${config.my.user.name}.openssh.authorizedKeys.keys = builtins.attrValues keys.yubikey;
}
