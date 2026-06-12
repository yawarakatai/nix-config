{ ... }:

{
  services.borgbackup.jobs.dane = {
    paths = [
      "/data"
      "/home"
    ];
    repo = "/backup/borg/dane";
    encryption.mode = "none";
    compression = "auto,zstd";
    startAt = "daily";
    prune.keep = {
      daily = 7;
      weekly = 4;
      monthly = 6;
    };
  };
}
