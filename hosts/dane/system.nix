{ lib, ... }:

{
  my.router = {
    wan = "enP3p76s0";
    lan = "enP4p101s0";
    # dslite.v6connect.net (ASAHI Net); it only resolves through the FLET'S DNS.
    aftr = "2001:c28:1:301::11";
  };

  # Dane faces the network, so cracking its hash must not unlock the desktops.
  age.secrets.user-password.rekeyFile = lib.mkForce ../../secrets/user-password-dane.age;

  my.backupServer.quotas = {
    desuwa = "400G";
    nanodesu = "150G";
    kamo = "150G";
  };
}
