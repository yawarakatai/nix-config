{ pkgs, ... }:

{
  home.packages = [ pkgs.pixelorama ];

  xdg.dataFile."mime/packages/pixelorama.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
      <mime-type type="image/pxo">
        <comment>Pixelorama project</comment>
        <glob pattern="*.pxo"/>
      </mime-type>
    </mime-info>
  '';

  xdg.mimeApps = {
    enable = true;
    defaultApplications."image/pxo" = "com.orama_interactive.Pixelorama.desktop";
  };
}
