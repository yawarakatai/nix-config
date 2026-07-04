{ ... }:

{
  services.borgbackup.jobs.dane = {
    paths = [
      "/data"
      "/home"
    ];
    exclude = [
      "/data/shared/audiobooks"
      "/storage/shared/audiobooks"
    ];
    repo = "/storage/borg/dane";
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
