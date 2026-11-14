{
  config,
  lib,
  pkgs,
  ...
}:

let
  keys = import ../../secrets/keys.nix;

  # Master ciphertexts are public, so they must withstand harvest-now-decrypt-later attacks.
  pqPrefix = "# public key (pq safe): ";
  masterIdentity = identity: {
    inherit identity;
    pubkey = lib.removePrefix pqPrefix (
      lib.findFirst (lib.hasPrefix pqPrefix) (throw "${toString identity} lacks a post-quantum recipient")
        (lib.splitString "\n" (builtins.readFile identity))
    );
  };
in
{
  age.rekey = {
    # Host public key for rekeying, tracked under hosts/<host>/generated/.
    hostPubkey = keys.hosts.${config.networking.hostName};

    # PIN-protected YubiKey FIDO2 identities; either key can decrypt.
    masterIdentities = map masterIdentity [
      ../../secrets/master-key-5.pub
      ../../secrets/master-key-5c.pub
    ];

    storageMode = "local";
    localStorageDir = ../../secrets/rekeyed/${config.networking.hostName};

    agePlugins = [
      pkgs.age-plugin-fido2-hmac
      # Provides age-plugin-pq, which lets agenix-rekey's rage encrypt to ML-KEM recipients.
      pkgs.age
    ];
  };
}
