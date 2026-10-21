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

# treefmt is checked by nix flake check; validation must not rewrite sources.
check:
    just lint
    just dead
    nix flake check --all-systems
