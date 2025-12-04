# Coding Guide

Coding standards for this NixOS configuration.

## General Principles

1. **DRY** - Use shared libraries (`lib/`), don't duplicate code
2. **Single Source of Truth** - Colors in theme file, monitor config in `vars.nix`
3. **Modularity** - One module = one purpose
4. **Declarative** - Describe desired state, not steps

## Nix Code Style

### Formatting

- 2 spaces for indentation (no tabs)
- Multi-line lists and attribute sets for readability
- Break long lines at logical points

```nix
{ config, lib, pkgs, theme, vars, ... }:

let
  termColors = import ../../../lib/terminal-colors.nix { inherit theme; };
in
{
  programs.alacritty = {
    enable = true;
    settings = {
      font.size = theme.font.size;
      colors.primary.background = termColors.primary.background;
    };
  };
}
```

### Comments

```nix
# Good: Explain why, not what
color0 = termColors.ansi.black;

# Bad: Obvious comment
# Set color 0
color0 = termColors.ansi.black;  # black
```

## Module Structure

```nix
# Brief description of what this module does
{ config, lib, pkgs, theme, vars, ... }:

let
  # Local helpers
  termColors = import ../../../lib/terminal-colors.nix { inherit theme; };
in
{
  programs.myprogram = {
    enable = true;
    settings = {
      # Theme Integration - use theme values, never hard-code
      background = theme.colorScheme.base00;
      font.family = theme.font.name;
    };
  };
}
```

### Module Types

- **System** (`modules/system/`): Services, kernel modules, hardware
- **Home** (`modules/home/`): User programs, dotfiles, themes
- **Library** (`lib/`): Pure functions, shared utilities

## Theme Integration

**Never hard-code colors or fonts:**

```nix
# Bad
background = "#000000";
font = "CommitMono Nerd Font";

# Good
background = theme.colorScheme.base00;
font = theme.font.name;
```

Use semantic colors when appropriate:
- `theme.semantic.error`, `theme.semantic.success`, `theme.semantic.warning`
- `theme.opacity.terminal`, `theme.opacity.bar`
- `theme.border.width`, `theme.border.color`

## Naming Conventions

- **Files**: `lowercase-with-hyphens.nix`
- **Directories**: `lowercase`
- **Variables**: `camelCase`
- **Host names**: Must match across `hosts/`, flake output, and `vars.hostname`

## File Organization

```
lib/                    # Shared libraries
modules/
  system/              # NixOS modules
  home/                # Home Manager modules
hosts/hostname/        # Per-host configuration
  vars.nix             # Host variables
  configuration.nix    # System config
home/hostname/home.nix # Home Manager config
```

## Git Workflow

### Commit Messages

```
<type>: <subject>

feat: add ghostty terminal config
fix: correct yazi config for v0.3 API
refactor: extract terminal colors to shared library
```

Types: `feat`, `fix`, `refactor`, `docs`, `style`, `perf`, `chore`

### Before Committing

```bash
nix flake check              # Syntax check
nixos-rebuild build --flake .#desuwa  # Build test
```

## Common Patterns

### Host-Specific Values

```nix
# In vars.nix
{ username = "yawarakatai"; hostname = "desuwa"; }

# In module
{ time.timeZone = vars.timezone; }
```

### Conditional Configuration

```nix
config = lib.mkIf config.myModule.enable { ... };
```

## Anti-Patterns

- Hard-coding colors, fonts, or host-specific values
- Duplicating code across modules
- Mixing system and home-manager concerns
- Committing without testing
- Monolithic modules (split by concern)

## Resources

- [Nix Pills](https://nixos.org/guides/nix-pills/)
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
