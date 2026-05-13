{
  mountOptions ? [
    "compress=zstd"
    "noatime"
  ],
}:

{
  "@" = {
    mountpoint = "/";
    inherit mountOptions;
  };
  "@home" = {
    mountpoint = "/home";
    inherit mountOptions;
  };
  "@nix" = {
    mountpoint = "/nix";
    inherit mountOptions;
  };
  "@log" = {
    mountpoint = "/var/log";
    inherit mountOptions;
  };
}
