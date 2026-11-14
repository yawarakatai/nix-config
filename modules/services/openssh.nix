{ username, ... }:
let
  keys = import ../../secrets/keys.nix;
in
{
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      # FIDO keys must prove a PIN was entered; this has no effect on non-FIDO keys such as backup clients' host keys.
      PubkeyAuthOptions = "verify-required";
    };
  };

  users.users.${username}.openssh.authorizedKeys.keys = builtins.attrValues keys.ssh;
}
