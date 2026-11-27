# Keeps this host's Syncthing device ID across reinstalls: the ID is the hash of
# cert.pem, so peers' lists in ./home.nix stay valid without edits.
{ config, username, ... }:

let
  host = config.networking.hostName;
in
{
  age.secrets.syncthing-key = {
    rekeyFile = ../../secrets + "/syncthing-key-${host}.age";
    owner = username;
    mode = "0400";
  };

  home-manager.users.${username}.services.syncthing = {
    # The certificate is public: peers receive it in every TLS handshake.
    cert = "${../../hosts + "/${host}/syncthing-cert.pem"}";
    key = config.age.secrets.syncthing-key.path;
  };
}
