# AGENTS.md

## Repository goal

This repository is a personal NixOS/Home Manager configuration. It uses flake-parts and is being refactored toward a dendritic/aspect-oriented architecture.

## Architecture

- `modules/flake/` contains flake-parts entry modules.
- `modules/flake/aspects.nix` exports reusable NixOS and Home Manager aspects.
- `modules/profiles/` contains profile aggregations.
- `modules/home/` contains Home Manager feature implementations.
- `modules/desktop/` contains desktop/session/compositor/shell modules.
- `hosts/` contains host-specific configuration and hardware facts.
- `secrets/` contains age/agenix secrets and must be treated as high-risk.

## Design rules

- Prefer behavior-preserving changes.
- Keep profiles as aggregators only.
- Keep host files limited to host-specific facts and exceptions.
- Importing an aspect should generally enable it; do not add custom enable options unless explicitly requested.
- Avoid broad abstractions unless they reduce actual duplication.
- Do not reintroduce removed components: madori, kanshi, vicinae, waybar, mako, gura integration, juice, devenv, Jovian/GNOME handheld stack.
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
- Desktop profile aggregation: `modules/profiles/home/desktop*.nix` and `modules/flake/aspects.nix`
- Host-specific configuration: `hosts/<host>/default.nix`
- Server services: `features/server/` until moved into `modules/server/`

## High-risk areas

Do not modify these unless explicitly requested:

- `secrets/`
- agenix or agenix-rekey configuration
- disk layout and disko files
- LUKS, Secure Boot, or TPM settings
- hardware-configuration files
- production server service data paths

## Validation

After Nix refactors, run:

```bash
nix fmt
nix flake check
nix eval --raw .#nixosConfigurations.desuwa.config.system.build.toplevel.drvPath
nix eval --raw .#nixosConfigurations.nanodesu.config.system.build.toplevel.drvPath
nix eval --raw .#nixosConfigurations.dane.config.system.build.toplevel.drvPath
nix build .#nixosConfigurations.desuwa.config.system.build.toplevel
```

If a change only touches server services, evaluating `dane` is required. If a change touches desktop behavior, building `desuwa` is required.

## Refactor policy

- Move files in small phases.
- Keep aspect names stable when moving implementation files.
- Do not introduce `import-tree` until the `modules/` tree is fully converted and helper files are clearly marked.
- Prefer explicit imports over implicit magic while refactoring.
- Summarize moved files, updated imports, and behavior changes after each task.
