default:
    just --list

fmt:
    nix fmt

lint:
    statix check -i 'hosts/*/generated/hardware-configuration.nix'

dead:
    deadnix --fail --exclude hosts/*/generated/hardware-configuration.nix

eval host:
    nix eval --raw .#nixosConfigurations.{{ host }}.config.system.build.toplevel.drvPath

build host:
    nix build .#nixosConfigurations.{{ host }}.config.system.build.toplevel

eval-home name:
    nix eval --raw .#homeConfigurations.{{ name }}.activationPackage.drvPath

eval-homes:
    nix eval --json .#homeConfigurations --apply 'homes: builtins.mapAttrs (_: home: home.activationPackage.drvPath) homes'

# treefmt is checked by nix flake check; validation must not rewrite sources.
check:
    just lint
    just dead
    just eval-homes
    nix flake check --all-systems
