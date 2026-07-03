{ inputs, ... }:

{
  flake.modules = {
    nixos = rec {
      core = {
        imports = [
          ../../features
          ../core
        ];
      };

      servicesTailscale = {
        imports = [
          ../services/tailscale.nix
        ];
      };

      servicesOpenSsh = {
        imports = [
          ../services/openssh.nix
        ];
      };

      hardware = {
        imports = [
          ../hardware/audio.nix
          ../hardware/bluetooth.nix
        ];
      };

      themeStylix = {
        imports = [
          inputs.stylix.nixosModules.stylix
          ../theme
        ];
      };

      desktopWayland = {
        imports = [
          ../desktop/wayland.nix
        ];
      };

      desktopGreetd = {
        imports = [
          ../desktop/greetd.nix
        ];
      };

      desktopNiri = {
        imports = [
          ../desktop/niri/system.nix
        ];
      };

      profileBase = {
        imports = [
          inputs.disko.nixosModules.disko
          ../../lib/options.nix
          core
          ../storage
          servicesTailscale
          ../input/keyboard/kanata.nix
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
          ../core/i18n.nix
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
          ../core/i18n.nix
          desktopWayland
          themeStylix
          hardware
          desktopGreetd
          desktopNiri
        ];
      };

      profileLaptop = {
        imports = [
          profileDesktopNiri
          ../laptop/power.nix
          ../laptop/lid.nix
        ];
      };

      profileServer = {
        imports = [
          profileSecret
          ../core/locale.nix
          ../../features/server
        ];
      };
    };

    homeManager = rec {
      cli = {
        imports = [
          ../home/cli
        ];
      };

      dev = {
        imports = [
          ../home/dev
        ];
      };

      shell = {
        imports = [
          ../home/shell
        ];
      };

      editor = {
        imports = [
          ../home/editor/helix.nix
        ];
      };

      desktopNoctalia = {
        imports = [
          ../desktop/noctalia.nix
        ];
      };

      desktopNiri = {
        imports = [
          ../desktop/niri/home
        ];
      };

      desktopGhostty = {
        imports = [
          ../home/terminal/ghostty.nix
        ];
      };

      desktopDisplayTools =
        { pkgs, ... }:
        {
          home.packages = [
            pkgs.wlr-randr
          ];
        };

      profiles = {
        base = {
          imports = [
            ../profiles/home/default.nix
          ];
        };

        desktop = {
          imports = [
            ../profiles/home/desktop.nix
            desktopGhostty
          ];
        };

        desktopNiri = {
          imports = [
            ../profiles/home/desktop-niri.nix
          ];
        };

        server = {
          imports = [
            ../profiles/home/server.nix
          ];
        };
      };
    };
  };
}
