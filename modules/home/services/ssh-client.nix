{
  config,
  lib,
  ...
}:
let
  keys = import ../../../secrets/keys.nix;
  identities = config.my.ssh.identityFiles;

  # install-host creates each host key; hosts not installed yet are skipped.
  installedHosts = lib.filterAttrs (
    host: _: builtins.pathExists ../../../hosts/${host}/generated/ssh_host_ed25519_key.pub
  ) keys.hosts;

  # From https://api.github.com/meta, so the first connection cannot be intercepted.
  githubHostKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";

  yubikey = {
    identityFile = identities;
    identitiesOnly = true;
    identityAgent = "none";
  };
in
{
  options.my.ssh.identityFiles = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [
      "~/.ssh/yubikey_5"
      "~/.ssh/yubikey_5c"
    ];
    description = "SSH identity files used for hosts managed by this configuration.";
  };

  config = {
    home.file = {
      ".ssh/yubikey_5.pub".text = keys.ssh.yubikey-5;
      ".ssh/yubikey_5c.pub".text = keys.ssh.yubikey-5c;
      ".ssh/known_hosts_managed".text = lib.concatLines (
        lib.mapAttrsToList (host: key: "${host} ${key}") installedHosts ++ [ "github.com ${githubHostKey}" ]
      );
    };

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings =
        # The alias pins each host's key even when DHCP changes its address.
        lib.mapAttrs (
          host: _:
          yubikey
          // {
            hostKeyAlias = host;
          }
          # dayo is the router, so its LAN address is fixed.
          // lib.optionalAttrs (host == "dayo") { hostname = "192.168.1.1"; }
        ) installedHosts
        // {
          "*" = {
            setEnv = "TERM=xterm-256color";
            userKnownHostsFile = "~/.ssh/known_hosts ~/.ssh/known_hosts_managed";
          };

          "github.com" = yubikey // {
            user = "git";
          };

          "192.168.*" = yubikey;
        };
    };
  };
}
