# AGENTS.md

Personal NixOS/Home Manager configuration built on flake-parts, being refactored toward a dendritic/aspect-oriented architecture.

## Layout

- `modules/flake/`: flake-parts entry modules. `module-registry.nix` only publishes stable NixOS/Home Manager module names; it owns no feature implementation.
- `modules/profiles/`: aggregators only. Import feature modules directly instead of reaching back through `self.modules`.
- `modules/home/`, `modules/desktop/`: feature implementations.
- `hosts/<host>/`: host-specific facts and exceptions only (`default.nix` import glue, `system.nix`, `hardware.nix`, `home/`, `storage/`, `generated/`).
- `secrets/`: encrypted age/agenix files.

Non-obvious edit locations:

- Wallpaper: `my.wallpaper.*` in host `system.nix`; Noctalia writes wallpaper state.
- NixOS login shell and global shell initialization: `modules/core/users.nix`.
- Home Manager desktop aggregation, including development and SSH: `modules/profiles/home/desktop.nix`.
- Standalone portable account parameters: `modules/flake/home.nix`; installation: `PORTABLE.md`.
- Kamo gaming/session integration: `modules/gaming/jovian.nix`.
- Dayo's router and backup server: `modules/services/router.nix` and `modules/services/backup-server.nix`; line facts and quotas in `hosts/dayo/system.nix`. Backup clients: `modules/services/backup-client.nix`, not yet imported until dayo is installed.
- Security model and procedures: `SECURITY.md`; update it when changing secrets, SSH, YubiKey use, or `dayo`'s exposure.
- Desuwa's screen-recording account: `modules/desktop/recording-user.nix`; its Home Manager profile: `modules/profiles/home/recording.nix`.

## Design rules

- Importing an aspect enables it; do not add custom enable options unless asked.
- Keep aspect names stable when moving implementation files.
- Prefer explicit imports; do not introduce `import-tree` unless asked.
- Refactors should preserve behavior and move in small phases, each validated and committed separately.

## Ownership

- Noctalia owns wallpaper. Stylix owns colors, fonts, cursor, and application theming only; do not add `stylix.image`.
- Niri owns compositor behavior, keybindings, window rules, and output defaults. wlr-randr wrappers are for emergency display changes.
- When Home Manager manages Zsh or Starship, skip the duplicate NixOS initialization; hosts without those features keep the NixOS defaults.
- On `dayo`, systemd-networkd and nftables own networking; NetworkManager comes only from the desktop profile.
- On `kamo`, Jovian owns Gaming Mode, SDDM, input integration, and charging limits; Niri is the development desktop. Noctalia's agenix storage key is host-specific because of autologin.

## High-risk areas

Modify only when the task explicitly covers them (for example host installation or secret provisioning):

- `secrets/`, agenix and agenix-rekey configuration
- disk layout (`hosts/<host>/storage/disko.nix`), LUKS, Secure Boot, TPM
- `hosts/<host>/generated/`

Encrypted `.age` files, SSH public keys, and generated hardware configurations are versioned artifacts and may be committed. Never expose decrypted secret values.

## Validation

- Always: `just check` (read-only; treefmt is checked, not applied). Run `nix fmt` to fix formatting.
- Desktop or system changes: also `just build desuwa`.
- Changes to `modules/flake/home.nix`: also evaluate with `PORTABLE_USERNAME`/`PORTABLE_HOME` overrides (requires `--impure`).

## Documentation

Document lasting architecture, ownership, edit locations, and workflows by updating existing text. Omit task history and details already clear from code.
