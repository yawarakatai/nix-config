# nix-config

Personal NixOS and Home Manager configuration, built with flake-parts.

## Hosts

| Host       | Device                      | Arch            | Role             |
| ---------- | --------------------------- | --------------- | ---------------- |
| `desuwa`   | Desktop (RTX 3080, 32 GiB) | `x86_64-linux`  | Gaming machine   |
| `dayo`     | ROCK 5T (24 GiB)            | `aarch64-linux` | Router, backups  |
| `nanodesu` | Laptop                      | `x86_64-linux`  | Laptop           |
| `kamo`     | ROG Ally                    | `x86_64-linux`  | Portable machine |

## Documentation

- [Architecture](docs/architecture.md): layout, profiles, ownership, and where to edit
- [Installing a host](docs/install.md)
- [Security](docs/security.md): YubiKeys, secrets, SSH, and exposure
- [Portable environment](docs/portable.md): Home Manager on non-NixOS Linux
- Host operations: [dayo](hosts/dayo/README.md), [kamo](hosts/kamo/README.md)

## Common commands

```bash
# Format
nix fmt

# Full check: lint, dead code, formatting, evaluation of every host and
# Home Manager output, host assertions, and VM tests (does not rewrite files)
nix flake check --all-systems

# Build one host
nh os build -H kamo

# Switch the current machine
nh os switch
```
