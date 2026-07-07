default:
    just --list

fmt:
    nix fmt

lint:
    statix check

dead:
    deadnix --fail

eval host:
    nix eval --raw .#nixosConfigurations.{{host}}.config.system.build.toplevel.drvPath

build host:
    nix build .#nixosConfigurations.{{host}}.config.system.build.toplevel

check:
    just fmt
    just lint
    just dead
    nix flake check --all-systems
