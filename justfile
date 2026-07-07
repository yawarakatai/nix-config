default:
    just --list

fmt:
    nix fmt

lint:
    statix check .    

dead:
    deadnix --fail .

eval-all:
    nix eval --raw .#nixosConfigurations.desuwa.config.system.build.toplevel.drvPath
    nix eval --raw .#nixosConfigurations.nanodesu.config.system.build.toplevel.drvPath
    nix eval --raw .#nixosConfigurations.dane.config.system.build.toplevel.drvPath

check:
    nix fmt
    just lint
    just dead
    nix flake check
    just eval-all

build-desuwa:
    nix build .#nixosConfigurations.desuwa.config.system.build.toplevel

full-check:
    just check
    just build-desuwa

eval host:
    nix eval --raw .#nixosConfigurations.{{host}}.config.system.build.toplevel.drvPath

build host:
    nix build .#nixosConfigurations.{{host}}.config.system.build.toplevel
