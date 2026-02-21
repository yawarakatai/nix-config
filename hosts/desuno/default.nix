{ pkgs, ... }:

{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix

    ../../modules/system/gaming # Steam
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Tmp on tmpfs for better performance
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "50%";
  };

  # --- Application and Service Settings ---;
  environment.sessionVariables = {
    __GL_SHADER_DISK_CACHE = "1";
    __GL_THREADED_OPTIMIZATION = "1";
  };

  # --- My Options ---

  my = {
    system.monitors.primary = {
      name = "DP-1";
      width = 3840;
      height = 2160;
      refresh = 59.940;
      vrr = true;
    };
  };

  # --- State Version ---
  # State version - DO NOT CHANGE after initial install
  system.stateVersion = "25.05";
}
