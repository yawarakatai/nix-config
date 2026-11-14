{ osConfig, ... }:
# NixOS desktops: identities come from ./system.nix instead of ~/.ssh.
{
  imports = [ ./client.nix ];

  my.ssh.identityFiles = [
    osConfig.age.secrets.yubikey-5-sk.path
    osConfig.age.secrets.yubikey-5c-sk.path
  ];

  services.ssh-agent.enable = true;
}
