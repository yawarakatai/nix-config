{ pkgs, vars, ... }:

{
  # Agenix-rekey configuration
  age.rekey = {
    # Host public key for rekeying (from /etc/ssh/ssh_host_ed25519_key.pub)
    hostPubkey = "/etc/ssh/ssh_host_ed25519_key.pub";

    # Master identity (YubiKey FIDO2)
    masterIdentities = [
      ../../../secrets/master-key-5.pub
      ../../../secrets/master-key-5c.pub
    ];

    # Use local storage mode
    storageMode = "local";
    localStorageDir = ../../../secrets/rekeyed/${vars.hostname};

    # FIDO2 plugin for YubiKey
    agePlugins = [ pkgs.age-plugin-fido2-hmac ];
  };
}
