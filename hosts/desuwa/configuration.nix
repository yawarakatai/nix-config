{ vars, ... }:

{
  imports = [
    # Shared base configuration (common settings for all hosts)
    ../../modules/system/base.nix

    # Hardware-specific modules for this host
    ../../modules/system/nvidia.nix # NVIDIA RTX 3080
    ../../modules/system/logiops.nix # Logitech mouse
    ../../modules/system/lofreeflowlite.nix # Lofree Flow keyboard
    ../../modules/system/steam.nix # Steam
  ];

  # Host-specific user password
  # Password hash generated with: mkpasswd -m sha-512
  users.users.${vars.username}.hashedPassword = "$6$KtMQPtEMmQ9AW7qK$tvtWeUA5GzWyILnexkH51.OMTnM6cuzA2aEymac264HctHr5jRBH7NBOOn4twZqaF963f8KkgDdNzfpSfd54D0";

  services.flatpak.enable = true;

  virtualisation.docker.enable = false;

  environment.sessionVariables = {
    __GL_SHADER_DISK_CACHE = "1";
    __GL_THREADED_OPTIMIZATION = "1";
  };

  # Those are for when Davinci Resolve won't work well
  # environment.systemPackages = with pkgs; [
  #   ocl-icd
  # ];

  # hardware.graphics = {
  #   enable = true;
  #   extraPackages = with pkgs; [
  #     nvidia-vaapi-driver
  #     ocl-icd
  #     opencl-headers
  #   ];
  # };

  # Tmp on tmpfs for better performance
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "50%";
  };

  # State version - DO NOT CHANGE after initial install
  system.stateVersion = "25.05";
}
