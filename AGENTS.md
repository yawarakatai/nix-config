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
- `secrets/` contains age/agenix secrets and must be treated as high-risk.

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

## Where to edit

- Niri keybindings: `modules/desktop/niri/home/binds.nix`
- Niri window rules: `modules/desktop/niri/home/window-rules.nix`
- Niri output/settings: `modules/desktop/niri/home/settings.nix`
- Noctalia: `modules/desktop/noctalia.nix`
- Ghostty: `modules/home/terminal/ghostty.nix`
- CLI tools: `modules/home/cli/default.nix`
- Development tools: `modules/home/dev/default.nix`
- Shell/zsh/starship: `modules/home/shell/`
- Helix: `modules/home/editor/helix.nix`
- Desktop profile aggregation: `modules/profiles/home/desktop*.nix`
- Flake module registry: `modules/flake/module-registry.nix`
- Host import glue: `hosts/<host>/default.nix`
- Host-specific system settings: `hosts/<host>/system.nix`
- Host-specific hardware imports and quirks: `hosts/<host>/hardware.nix`
- Host disk layout: `hosts/<host>/storage/disko.nix`
- Generated host facts: `hosts/<host>/generated/`
- Server services: `modules/server/`

## High-risk areas

Do not modify these unless explicitly requested:

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
- Never commit unrelated changes, unvalidated changes, secrets, or high-risk configuration changes.
- Do not update `flake.lock` unless explicitly requested.

## Validation

After normal Nix refactors, prefer:

```bash
nix develop -c just check
```

For desktop or system-level changes, prefer:

```bash
nix develop -c just full-check
```

Equivalent manual commands for environments without `just`:

```bash
nix fmt
nix flake check
nix eval --raw .#nixosConfigurations.desuwa.config.system.build.toplevel.drvPath
nix eval --raw .#nixosConfigurations.nanodesu.config.system.build.toplevel.drvPath
nix eval --raw .#nixosConfigurations.dane.config.system.build.toplevel.drvPath
nix build .#nixosConfigurations.desuwa.config.system.build.toplevel
```

If a change only touches server services, evaluating `dane` is required. If a change touches desktop behavior, building `desuwa` is required.

If validation cannot be run, report the exact command that was skipped and why.

## Documentation

- Update `AGENTS.md` or repository docs when changing architecture, validation commands, ownership boundaries, important edit locations, or refactor policy.
- Summarize moved files, updated imports, and behavior changes after each task.
