{ inputs, ... }:

{
  flake.modules = {
    nixos = {
      core = {
        imports = [
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
          ../profiles/system/base.nix
        ];
      };

      # Headless hosts that only need local administration over SSH.
      profileMinimal = {
        imports = [
          ../profiles/system/minimal.nix
        ];
      };

      profileSecret = {
        imports = [
          ../profiles/system/secret.nix
        ];
      };

      profileDesktop = {
        imports = [
          ../profiles/system/desktop.nix
        ];
      };

      profileDesktopNiri = {
        imports = [
          ../profiles/system/desktop-niri.nix
        ];
      };

      profileLaptop = {
        imports = [
          ../profiles/system/laptop.nix
        ];
      };

      profileServer = {
        imports = [
          ../profiles/system/server.nix
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

      homeNoctalia = {
        imports = [
          ../desktop/noctalia.nix
        ];
      };

      homeNiri = {
        imports = [
          ../desktop/niri/home
        ];
      };

      homeGhostty = {
        imports = [
          ../home/terminal/ghostty.nix
        ];
      };

      homeDisplayTools =
        { pkgs, ... }:
        {
          home.packages = [
            pkgs.wlr-randr
          ];
        };

      profiles = {
        minimal = {
          imports = [
            ../profiles/home/minimal.nix
          ];
        };

        base = {
          imports = [
            ../profiles/home/default.nix
          ];
        };

        desktop = {
          imports = [
            ../profiles/home/desktop.nix
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
