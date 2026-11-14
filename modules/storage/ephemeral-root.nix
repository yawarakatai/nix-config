{ config, inputs, ... }:

let
  # The host's disk layout mounts a tmpfs on / and keeps only /nix on disk.
  persist = "/nix/persist";
in
{
  imports = [ inputs.preservation.nixosModules.default ];

  preservation = {
    enable = true;
    preserveAt.${persist} = {
      directories = [
        # uid and gid allocations, so files on other disks keep their owners.
        {
          directory = "/var/lib/nixos";
          inInitrd = true;
        }
        # Timer stamps, the saved clock, the random seed, and DHCP server leases.
        "/var/lib/systemd"
        # Earlier boots' logs, to diagnose a crash or watchdog reset.
        "/var/log"
      ];
      # systemd derives the DHCPv6 DUID from it and splits the journal by it.
      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
          how = "symlink";
          configureParent = true;
        }
      ];
    };
  };

  # The first boot generates the ID and commits it through the symlink.
  boot.initrd.systemd.tmpfiles.settings.preservation."/sysroot${persist}/etc/machine-id".f.argument =
    "uninitialized";
  systemd.services.systemd-machine-id-commit = {
    unitConfig.ConditionPathIsMountPoint = [
      ""
      "${persist}/etc/machine-id"
    ];
    serviceConfig.ExecStart = [
      ""
      "${config.systemd.package}/bin/systemd-machine-id-setup --commit --root ${persist}"
    ];
  };

  # agenix decrypts with this key, so it is read in place rather than mounted.
  # Other key types would be regenerated at every boot.
  services.openssh.hostKeys = [
    {
      path = "${persist}/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }
  ];
}
