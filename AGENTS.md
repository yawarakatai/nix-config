# AGENTS.md

## Repository goal

This repository is a personal NixOS/Home Manager configuration. It uses flake-parts and is being refactored toward a dendritic/aspect-oriented architecture.

## Architecture

- `modules/flake/` contains flake-parts entry modules.
- `modules/flake/module-registry.nix` publishes stable reusable NixOS and Home Manager module names.
- `modules/profiles/` contains profile aggregations.
- `modules/home/` contains Home Manager feature implementations.
- `modules/desktop/` contains desktop/session/compositor/shell modules.
- `hosts/` contains host-specific configuration and hardware facts.
- `secrets/` contains encrypted age/agenix files; secret handling and recipient changes are high-risk.

## Design rules

### Refactor shape

- Prefer behavior-preserving changes.
- Move files in small phases.
- Keep aspect names stable when moving implementation files.
- Keep profiles as aggregators only.
- Keep `modules/flake/module-registry.nix` thin; it should publish stable names, not own feature implementation.
- Profiles should import feature modules directly instead of reaching back through `self.modules`.
- Keep host files limited to host-specific facts and exceptions.
- Importing an aspect should generally enable it; do not add custom enable options unless explicitly requested.
- Avoid broad abstractions unless they reduce actual duplication.
- Prefer explicit imports over implicit magic while refactoring.
- Do not introduce `import-tree` unless explicitly requested.

### Ownership boundaries

- Noctalia owns wallpaper.
- Stylix owns colors, fonts, cursor, and application theming only.
- Do not add `stylix.image`.
- Niri owns compositor behavior, keybindings, window rules, and output defaults.
- wlr-randr wrappers are used for emergency display changes.
- When Home Manager manages Zsh or Starship, avoid the corresponding duplicate NixOS initialization. Hosts without those Home Manager features retain the NixOS defaults.
- On `kamo`, Jovian owns Gaming Mode, SDDM, input integration, and charging limits; Niri is the development desktop. Noctalia's agenix storage key is host-specific because of autologin.

## Where to edit

- Niri keybindings: `modules/desktop/niri/home/binds.nix`
- Niri window rules: `modules/desktop/niri/home/window-rules.nix`
- Niri output/settings: `modules/desktop/niri/home/settings.nix`
- Noctalia: `modules/desktop/noctalia.nix`
- Wallpaper options: `my.wallpaper.*` in host `system.nix`; Noctalia writes wallpaper state
- Ghostty: `modules/home/terminal/ghostty.nix`
- CLI tools: `modules/home/cli/default.nix`
- Development tools: `modules/home/dev/default.nix`
- Shell/zsh/starship: `modules/home/shell/`
- NixOS login shell and global initialization: `modules/core/users.nix`
- Helix: `modules/home/editor/helix.nix`
- Home Manager shared basics: `modules/profiles/home/default.nix`
- Home Manager desktop aggregation (including development and SSH): `modules/profiles/home/desktop.nix`
- Host-only Home Manager additions: `hosts/<host>/home/default.nix`
- Kamo gaming/session integration: `modules/gaming/jovian.nix`; host exceptions: `hosts/kamo/`
- Standalone portable account parameters: `modules/flake/home.nix`; installation: `PORTABLE.md`
- Flake module registry: `modules/flake/module-registry.nix`
- Host import glue: `hosts/<host>/default.nix`
- Host-specific system, display, and wallpaper settings: `hosts/<host>/system.nix`
- Host-specific hardware imports and quirks: `hosts/<host>/hardware.nix`
- Host disk layout: `hosts/<host>/storage/disko.nix`
- Generated host facts: `hosts/<host>/generated/`
- Server services: `modules/server/`

## High-risk areas

Modify these only within explicitly authorized task scope, including required artifacts from an authorized host installation/reinstallation or secret-provisioning task:

- `secrets/`
- agenix or agenix-rekey configuration
- host disk layout and disko files, especially `hosts/<host>/storage/disko.nix`
- LUKS, Secure Boot, or TPM settings
- generated hardware-configuration files under `hosts/<host>/generated/`
- production server service data paths

## Git / Change management

- At the start of a task, inspect `git status --short`.
- If there are existing uncommitted changes, distinguish user changes from agent changes and do not overwrite or mix unrelated changes.
- For multi-step refactors, work in small validated phases and ask whether to create a checkpoint commit after each phase.
- At the end of a task, show the final worktree status, summarize changed files, and suggest an English conventional commit message.
- Do not create commits unless explicitly requested, or unless the user explicitly opted into auto-committing for the current task/session.
- Never commit unrelated or unvalidated changes, plaintext secrets, or private keys. Do not expose decrypted secret values in logs or responses.
- Encrypted `.age` files, SSH public keys, and generated hardware configurations are versioned artifacts, not automatically excluded from commits. Changes in high-risk areas may be committed when within the authorized task scope, reviewed, and validated. A commit request does not authorize unrelated changes in those areas.
- Do not update `flake.lock` unless explicitly requested.

## Validation

`just check` is read-only: formatting is validated by the flake's treefmt check.
Run `nix fmt` explicitly when formatting fixes are needed. Generated hardware
configurations are excluded from formatting, lint, and dead-code checks.
`just check` also runs `just eval-homes` to evaluate every standalone Home Manager
activation derivation without building its packages. `just eval-home <name>`
evaluates one output. These checks use pure evaluation and the default account;
portable account overrides (`PORTABLE_USERNAME`, `PORTABLE_HOME`) require
`--impure` and should also be tested when changing `modules/flake/home.nix`.

After normal Nix refactors, prefer:

```bash
nix develop -c just check
```

For desktop or system-level changes, run `check` and build the affected host:

```bash
nix develop -c just check
nix develop -c just build desuwa
```

Equivalent manual commands for environments without `just`:

```bash
nix fmt
nix flake check
nix eval --json .#homeConfigurations --apply 'homes: builtins.mapAttrs (_: home: home.activationPackage.drvPath) homes'
nix eval --raw .#nixosConfigurations.desuwa.config.system.build.toplevel.drvPath
nix eval --raw .#nixosConfigurations.nanodesu.config.system.build.toplevel.drvPath
nix eval --raw .#nixosConfigurations.dane.config.system.build.toplevel.drvPath
nix build .#nixosConfigurations.desuwa.config.system.build.toplevel
```

If a change only touches server services, evaluating `dane` is required. If a change touches desktop behavior, building `desuwa` is required.

If validation cannot be run, report the exact command that was skipped and why.

## Documentation

- Document lasting architecture, validation commands, ownership, edit locations, refactor policy, and user workflows. Prefer updating existing text; omit task history, temporary blockers, and implementation details already clear from code.
- Summarize moved files, updated imports, and behavior changes after each task.
