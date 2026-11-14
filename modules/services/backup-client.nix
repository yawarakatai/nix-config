{ config, pkgs, ... }:

let
  keys = import ../../secrets/keys.nix;
  host = config.networking.hostName;
  # The alias pins dayo's host key; root has no other known_hosts for unattended runs.
  dayoKnownHosts = pkgs.writeText "dayo-known-hosts" "dayo ${keys.hosts.dayo}\n";
in
{
  # Needs dayo's generated host key, so import it only after dayo is installed.
  age.secrets.borg-passphrase = {
    rekeyFile = ../../secrets + "/borg-passphrase-${host}.age";
    # `agenix generate` creates it; the YubiKeys can recover it from Git if this host is lost.
    generator.script = "passphrase";
  };

  # Pushes to this host's append-only repository on dayo (see backup-server.nix).
  services.borgbackup.jobs.dayo = {
    repo = "borg@192.168.1.1:.";
    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat ${config.age.secrets.borg-passphrase.path}";
    };
    environment.BORG_RSH = toString [
      "ssh -i /etc/ssh/ssh_host_ed25519_key"
      "-o HostKeyAlias=dayo"
      "-o UserKnownHostsFile=${dayoKnownHosts}"
      "-o StrictHostKeyChecking=yes"
    ];
    paths = [ "/home" ];
    exclude = [
      "/home/*/.cache"
      "/home/*/.local/share/Steam"
      "/home/*/.local/share/Trash"
      "/home/*/.local/state/noctalia/clipboard"
    ];
    compression = "auto,zstd";
    startAt = "daily";
    # Laptops are often off at the scheduled time.
    persistentTimer = true;
    # Append-only: pruning only marks archives; dayo reclaims space on manual compaction.
    prune.keep = {
      daily = 7;
      weekly = 4;
      monthly = 6;
    };
  };
}
