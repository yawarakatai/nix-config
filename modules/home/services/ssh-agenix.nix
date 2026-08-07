{ osConfig, ... }:

{
  my.ssh.identityFiles = [
    osConfig.age.secrets.yubikey-5-sk.path
    osConfig.age.secrets.yubikey-5c-sk.path
  ];
}
