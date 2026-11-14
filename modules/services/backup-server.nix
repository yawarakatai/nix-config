{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkOption types;
  keys = import ../../secrets/keys.nix;
  cfg = config.my.backupServer;
  root = "/srv/backup";
  hosts = lib.attrNames cfg.quotas;
in
{
  # Clients push over the existing SSH server, so backups add no network listener.
  options.my.backupServer.quotas = mkOption {
    type = types.attrsOf types.str;
    description = "Borg storage quota per client host, which authenticates with its SSH host key.";
  };

  config = {
    services.borgbackup.repos = lib.mapAttrs (host: quota: {
      path = "${root}/${host}";
      # A compromised client can add archives but cannot destroy existing ones.
      authorizedKeysAppendOnly = [ keys.hosts.${host} ];
      inherit quota;
    }) cfg.quotas;

    systemd.services =
      lib.genAttrs (map (host: "borgbackup-repo-${host}") hosts) (_: {
        # Without the backup disk, repositories must not land on the root filesystem.
        unitConfig.RequiresMountsFor = root;
      })
      // {
        # Repository-only checks verify segment checksums without any client passphrase.
        borgbackup-check = {
          description = "Verify BorgBackup repository integrity";
          startAt = "monthly";
          unitConfig.RequiresMountsFor = root;
          environment.BORG_BASE_DIR = "/var/lib/borgbackup-check";
          serviceConfig = {
            Type = "oneshot";
            User = "borg";
            Group = "borg";
            StateDirectory = "borgbackup-check";
            Nice = 19;
            IOSchedulingClass = "idle";
            NoNewPrivileges = true;
            PrivateNetwork = true;
            ProtectSystem = "strict";
            ReadWritePaths = [ root ];
          };
          script = ''
            status=0
            for repo in ${lib.concatMapStringsSep " " (host: lib.escapeShellArg "${root}/${host}") hosts}; do
              # Repositories appear only after a client's first backup.
              [ -e "$repo/config" ] || continue
              ${lib.getExe' pkgs.borgbackup "borg"} check --repository-only --lock-wait 600 "$repo" || status=1
            done
            exit "$status"
          '';
        };
      };
  };
}
