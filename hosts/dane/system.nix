_:

{
  my.router = {
    wan = "enP3p76s0";
    lan = "enP4p101s0";
    # dslite.v6connect.net (ASAHI Net); it only resolves through the FLET'S DNS.
    aftr = "2001:c28:1:301::11";
  };

  my.backupServer.quotas = {
    desuwa = "400G";
    nanodesu = "150G";
    kamo = "150G";
  };
}
