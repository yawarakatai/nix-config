{ inputs, ... }:

{
  flake.modules = {
    nixos = rec {
      core = {
        imports = [
          ../../features
          ../../features/core
        ];
      };

      servicesTailscale = {
        imports = [
          ../../features/service/tailscale.nix
        ];
      };

      servicesOpenSsh = {
        imports = [
          ../../features/service/openssh.nix
        ];
      };

      hardware = {
        imports = [
          ../../features/hardware/audio.nix
          ../../features/hardware/bluetooth.nix
        ];
      };

      themeStylix = {
        imports = [
          inputs.stylix.nixosModules.stylix
          ../../features/theme
        ];
      };

      desktopWayland = {
        imports = [
          ../../features/desktop/wayland.nix
        ];
      };

      desktopGreetd = {
        imports = [
          ../../features/display/greetd.nix
        ];
      };

      profileBase = {
        imports = [
          inputs.disko.nixosModules.disko
          ../../lib/options.nix
          core
          ../../features/storage
          servicesTailscale
          ../../features/input/keyboard/kanata.nix
        ];
      };

      profileSecret = {
        imports = [
          profileBase
          inputs.agenix.nixosModules.default
          inputs.agenix-rekey.nixosModules.default
          ../../features/security
          servicesOpenSsh
        ];
      };

      profileDesktop = {
        imports = [
          profileSecret
          ../../features/core/i18n.nix
          desktopWayland
          themeStylix
          hardware
          desktopGreetd
        ];
      };

      profileDesktopNiri = {
        imports = [
          profileSecret
          inputs.niri.nixosModules.niri
          ../../features/core/i18n.nix
          desktopWayland
          themeStylix
          hardware
          desktopGreetd
          ../../features/niri/system.nix
        ];
      };

      profileLaptop = {
        imports = [
          profileDesktopNiri
          ../../features/laptop/power.nix
          ../../features/laptop/lid.nix
        ];
      };

      profileServer = {
        imports = [
          profileSecret
          ../../features/core/locale.nix
          ../../features/server
        ];
      };
    };

    homeManager = {
      cli = {
        imports = [
          ../../features/home/cli
        ];
      };

      dev = {
        imports = [
          ../../features/home/dev
        ];
      };

      shell = {
        imports = [
          ../../features/home/shell
        ];
      };

      editor = {
        imports = [
          ../../features/home/editor/helix.nix
        ];
      };

      desktopNoctalia = {
        imports = [
          ../../features/desktop/noctalia.nix
        ];
      };

      profiles = {
        base = {
          imports = [
            ../../features/home/profiles/default.nix
          ];
        };

        desktop = {
          imports = [
            ../../features/home/profiles/desktop.nix
          ];
        };

        desktopNiri = {
          imports = [
            ../../features/home/profiles/desktop-niri.nix
          ];
        };

        server = {
          imports = [
            ../../features/home/profiles/server.nix
          ];
        };
      };
    };
  };
}
