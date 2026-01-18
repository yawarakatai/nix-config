{ pkgs, ... }:

{
  imports = [
    ../../lib/options.nix
    ./hardware-configuration.nix

    # Hardware-specific modules
    ../../modules/system/hardware/gpu/nvidia.nix # NVIDIA RTX 3080
    ../../modules/system/input/mouse/logiops.nix # Logitech mouse
    ../../modules/system/input/keyboard/lofree.nix # Lofree Flow keyboard

    ../../modules/system/gaming # Steam
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "desuwa";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Tmp on tmpfs for better performance
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "50%";
  };

  # --- Locale Timezone Input methods ---

  time.timeZone = "Asia/Tokyo";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "ja_JP.UTF-8/UTF-8"
    ];
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

    # Japanese input method - fcitx5 with mozc
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-mozc
          fcitx5-gtk
        ];

        waylandFrontend = true;
      };
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # --- Application and Service Settings ---;
  services.flatpak.enable = true;
  virtualisation.docker.enable = false;

  environment.sessionVariables = {
    __GL_SHADER_DISK_CACHE = "1";
    __GL_THREADED_OPTIMIZATION = "1";
  };

  # --- My Options ---

  my = {
    user.name = "yawarakatai";
    system.monitors.primary = {
      name = "HDMI-A-1";
      width = 3840;
      height = 2160;
      refresh = 119.880;
      vrr = true;
    };
  };

  # --- State Version ---
  # State version - DO NOT CHANGE after initial install
  system.stateVersion = "25.05";
}
