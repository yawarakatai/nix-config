_:

{
  services.minecraft-server = {
    enable = true;
    eula = true;
    dataDir = "/var/lib/minecraft";
    jvmOpts = "-Xms2G -Xmx4G";
  };
}
