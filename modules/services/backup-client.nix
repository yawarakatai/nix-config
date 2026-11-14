{ config, pkgs, ... }:

let
  keys = import ../../secrets/keys.nix;
  host = config.networking.hostName;
  # The alias pins dane's host key; root has no other known_hosts for unattended runs.
  daneKnownHosts = pkgs.writeText "dane-known-hosts" "dane ${keys.hosts.dane}\n";
in
{
  # Needs dane's generated host key, so import it only after dane is installed.
  age.secrets.borg-passphrase = {
    rekeyFile = ../../secrets + "/borg-passphrase-${host}.age";
    # `agenix generate` creates it; the YubiKeys can recover it from Git if this host is lost.
    generator.script = "passphrase";
  };

  # Pushes to this host's append-only repository on dane (see backup-server.nix).
  services.borgbackup.jobs.dane = {
    repo = "borg@192.168.1.1:.";
    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat ${config.age.secrets.borg-passphrase.path}";
    };
    environment.BORG_RSH = toString [
      "ssh -i /etc/ssh/ssh_host_ed25519_key"
      "-o HostKeyAlias=dane"
      "-o UserKnownHostsFile=${daneKnownHosts}"
      "-o StrictHostKeyChecking=yes"
    ];
    paths = [ "/home" ];
    exclude = [
      "/home/*/.cache"
      "/home/*/.local/share/Steam"
      "/home/*/.local/share/Trash"
    ];
    compression = "auto,zstd";
    startAt = "daily";
    # Laptops are often off at the scheduled time.
    persistentTimer = true;
    # Append-only: pruning only marks archives; dane reclaims space on manual compaction.
    prune.keep = {
      daily = 7;
      weekly = 4;
      monthly = 6;
    };
  };
}
