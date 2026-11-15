{
  lib,
  pkgs,
  username,
  ...
}:

{
  # The home directory is a tmpfs and Home Manager sets up no zsh here, so zsh
  # would ask to create ~/.zshrc at the first login after every boot.
  users.users.${username}.shell = lib.mkForce pkgs.bashInteractive;

  # Predictable names follow PCIe bus numbers, which the devicetree assigns
  # differently between the firmware's and the kernel's copy.
  systemd.network.links = {
    "10-wan" = {
      matchConfig.PermanentMACAddress = "00:48:54:20:72:89";
      linkConfig.Name = "wan";
    };
    "10-lan" = {
      matchConfig.PermanentMACAddress = "00:48:54:20:72:8a";
      linkConfig.Name = "lan";
    };
  };

  my.router = {
    wan = "wan";
    lan = "lan";
    # dslite.v6connect.net (ASAHI Net); it only resolves through the FLET'S DNS.
    aftr = "2001:c28:1:301::11";
  };

  # Dayo faces the network, so cracking its hash must not unlock the desktops.
  age.secrets.user-password.rekeyFile = lib.mkForce ../../secrets/user-password-dayo.age;

  my.backupServer.quotas = {
    desuwa = "400G";
    nanodesu = "150G";
    kamo = "150G";
  };
}
