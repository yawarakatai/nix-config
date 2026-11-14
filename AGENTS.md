# Agent instructions

Personal NixOS/Home Manager configuration built on flake-parts, being refactored toward a dendritic/aspect-oriented architecture.

Read `docs/architecture.md` for the layout, ownership, and edit locations before changing structure or a feature's owner.

## Design rules

- Importing an aspect enables it; do not add custom enable options unless asked.
- Profiles are aggregators only: import feature modules directly instead of reaching back through `self.modules`.
- `modules/flake/module-registry.nix` only publishes stable module names; keep feature implementation out of it.
- `hosts/<host>/` holds host-specific facts and exceptions only.
- Keep aspect names stable when moving implementation files.
- Prefer explicit imports; do not introduce `import-tree` unless asked.
- Refactors should preserve behavior and move in small phases, each validated and committed separately.

## High-risk areas

Modify only when the task explicitly covers them (for example host installation or secret provisioning):

- `secrets/`, agenix and agenix-rekey configuration
- disk layout (`hosts/<host>/storage/disko.nix`), LUKS, Secure Boot, TPM
- `hosts/<host>/generated/`

Encrypted `.age` files, SSH public keys, and generated hardware configurations are versioned artifacts and may be committed. Never expose decrypted secret values.

## Validation

- Always: `nix flake check --all-systems` (read-only; treefmt is checked, not applied). Run `nix fmt` to fix formatting.
- Desktop or system changes: also `nh os build -H desuwa`.
- Changes to `modules/flake/home.nix`: also evaluate with `PORTABLE_USERNAME`/`PORTABLE_HOME` overrides (requires `--impure`).

## Documentation

Document lasting architecture, ownership, edit locations, and workflows by updating existing text. Omit task history and details already clear from code. State each fact in one place:

- `README.md`: overview, hosts, and an index only.
- `docs/architecture.md`: layout, profiles, ownership, where to edit.
- `docs/security.md`: update it when changing secrets, SSH, YubiKey use, or `dayo`'s exposure.
- `docs/install.md`: host installation; `docs/portable.md`: the standalone Home Manager configuration.
- `hosts/<host>/README.md`: that host's operations; module-local notes next to the module (for example `modules/theme/README.md`).
