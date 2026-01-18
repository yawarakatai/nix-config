{ config, pkgs, ... }:

let
  keys = import ../../../secrets/keys.nix;
in
{
  # Agenix-rekey configuration
  age.rekey = {
    # Host public key for rekeying (from /etc/ssh/ssh_host_ed25519_key.pub)
    hostPubkey = keys.hosts.${config.networking.hostName};

    # Master identity (YubiKey FIDO2)
    masterIdentities = [
      ../../../secrets/master-key-5.pub
      ../../../secrets/master-key-5c.pub
    ];

    # Use local storage mode
    storageMode = "local";
    localStorageDir = ../../../secrets/rekeyed/${config.networking.hostName};

    # FIDO2 plugin for YubiKey
    agePlugins = [ pkgs.age-plugin-fido2-hmac ];
  };
}
