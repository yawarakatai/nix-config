# Coding Guide & Conventions

This document outlines the coding standards, conventions, and best practices for this NixOS configuration.

## Table of Contents

- [General Principles](#general-principles)
- [Nix Code Style](#nix-code-style)
- [Module Structure](#module-structure)
- [Theme Integration](#theme-integration)
- [Naming Conventions](#naming-conventions)
- [Documentation Standards](#documentation-standards)
- [File Organization](#file-organization)
- [Git Workflow](#git-workflow)
- [Common Patterns](#common-patterns)
- [Anti-Patterns](#anti-patterns)

---

## General Principles

### 1. DRY (Don't Repeat Yourself)
- **Never duplicate code** - use shared libraries (`lib/`)
- Terminal colors: Use `lib/terminal-colors.nix`
- System settings: Extend `modules/system/base.nix`
- Create helpers for repeated patterns

### 2. Single Source of Truth
- **Colors**: `modules/home/themes/night-neon.nix`
- **Monitor config**: `hosts/*/vars.nix`
- **Base system settings**: `modules/system/base.nix`
- **Fonts**: Theme file (not scattered across modules)

### 3. Modularity
- One module = one purpose
- Clear, focused modules over monolithic configs
- Easy to enable/disable without breaking other parts

### 4. Declarative Over Imperative
- Describe the desired state, not steps to get there
- Use Nix expressions, not bash scripts (when possible)
- Let Nix handle dependencies and ordering

### 5. Type Safety
- Use proper Nix types in module options
- Validate inputs where possible
- Fail fast with clear error messages

---

## Nix Code Style

### Formatting

```nix
# ✅ GOOD: Consistent formatting
{ config, lib, pkgs, theme, vars, ... }:

let
  termColors = import ../../../lib/terminal-colors.nix { inherit theme; };
in
{
  programs.alacritty = {
    enable = true;

    settings = {
      font.size = theme.font.size;
      colors.primary = {
        background = termColors.primary.background;
        foreground = termColors.primary.foreground;
      };
    };
  };
}
```

```nix
# ❌ BAD: Inconsistent formatting
{config,lib,pkgs,theme,vars,...}:
{programs.alacritty={enable=true;settings={font.size=theme.font.size;colors.primary={background=termColors.primary.background;foreground=termColors.primary.foreground;};};};
}
```

### Indentation
- **2 spaces** for indentation (never tabs)
- Align `=` for readability in attribute sets
- Break long lines at logical points

```nix
# ✅ GOOD: Readable indentation
settings = {
  font = {
    family = theme.font.name;
    size = theme.font.size;
  };

  window = {
    padding = { x = 8; y = 8; };
    decorations = "none";
  };
};
```

### Comments

```nix
# ✅ GOOD: Descriptive section comments
# Terminal colors (0-15) - Using shared color scheme
# Normal colors
color0 = termColors.ansi.black;
color1 = termColors.ansi.red;
```

```nix
# ❌ BAD: Obvious or redundant comments
# Set color 0
color0 = termColors.ansi.black;  # black
```

### Let Bindings

```nix
# ✅ GOOD: Local helpers in let binding
let
  termColors = import ../../../lib/terminal-colors.nix { inherit theme; };
  fontSize = theme.font.size;
in
{
  # Use termColors and fontSize
}
```

```nix
# ❌ BAD: Repeated imports
{
  # Importing the same thing multiple times
  background = (import ../../../lib/terminal-colors.nix { inherit theme; }).primary.background;
  foreground = (import ../../../lib/terminal-colors.nix { inherit theme; }).primary.foreground;
}
```

### Lists and Attribute Sets

```nix
# ✅ GOOD: Multi-line for readability
imports = [
  ../../modules/system/base.nix
  ../../modules/system/boot.nix
  ../../modules/system/networking.nix
];

colors = {
  black = theme.colorScheme.base00;
  red = theme.colorScheme.base08;
  green = theme.colorScheme.base0B;
};
```

```nix
# ❌ BAD: Long single lines
imports = [ ../../modules/system/base.nix ../../modules/system/boot.nix ../../modules/system/networking.nix ];
```

---

## Module Structure

### Standard Module Template

Every module should follow this structure:

```nix
# Brief description of what this module does
{ config, lib, pkgs, theme, vars, ... }:

# Import shared libraries if needed
let
  # Local helpers and utilities
  termColors = import ../../../lib/terminal-colors.nix { inherit theme; };
in

{
  # ============================================================================
  # Module Options (if configurable)
  # ============================================================================
  # options.moduleName = { ... };

  # ============================================================================
  # Module Configuration
  # ============================================================================
  programs.myprogram = {
    enable = true;

    settings = {
      # Group settings logically with comments

      # Theme Integration
      background = theme.colorScheme.base00;
      foreground = theme.colorScheme.base05;

      # Font Configuration
      font = {
        family = theme.font.name;
        size = theme.font.size;
      };

      # Host-Specific Values
      # (Use vars for things that vary per host)
    };
  };

  # Additional packages if needed
  # home.packages = with pkgs; [ ... ];
}
```

### Module Organization

1. **Header**: Brief description
2. **Imports**: Function parameters
3. **Let bindings**: Local helpers
4. **Options**: Module options (if configurable)
5. **Config**: Actual configuration
6. **Sections**: Grouped logically with comments

### Module Types

#### System Module
```nix
# modules/system/mymodule.nix
{ config, lib, pkgs, vars, ... }:

{
  # System-level configuration
  # - Services
  # - Kernel modules
  # - System packages
  # - Hardware configuration
}
```

#### Home Module
```nix
# modules/home/category/mymodule.nix
{ config, pkgs, theme, vars, ... }:

{
  # User-level configuration
  # - Programs
  # - User packages
  # - Dotfiles
  # - Theme integration
}
```

#### Library Module
```nix
# lib/mylib.nix
{ theme }:  # Or other parameters

{
  # Pure functions
  # Shared utilities
  # No side effects
  # Returns data structures
}
```

---

## Theme Integration

### Golden Rule: NEVER Hard-Code Colors

```nix
# ❌ BAD: Hard-coded colors
background = "#000000";
accent = "#00ffff";
error = "#ff0066";
```

```nix
# ✅ GOOD: Use theme values
background = theme.colorScheme.base00;
accent = theme.semantic.info;
error = theme.semantic.error;
```

### Theme Value Hierarchy

1. **Semantic colors** (preferred for meaning)
   ```nix
   error = theme.semantic.error;      # Use for error states
   success = theme.semantic.success;  # Use for success states
   warning = theme.semantic.warning;  # Use for warnings
   ```

2. **Base16 colors** (for specific palette colors)
   ```nix
   background = theme.colorScheme.base00;
   foreground = theme.colorScheme.base05;
   cyan = theme.colorScheme.base0C;
   ```

3. **Opacity** (for transparency)
   ```nix
   opacity = theme.opacity.terminal;    # or .bar, .launcher, .notification
   ```

### Font Configuration

```nix
# ✅ GOOD: Use theme fonts
font = {
  family = theme.font.name;        # English font
  size = theme.font.size;
};

# For apps with CJK support
font.family = theme.font.family;   # Includes CJK fallback
```

```nix
# ❌ BAD: Hard-coded fonts
font = {
  family = "CommitMono Nerd Font";
  size = 14;
};
```

### Border and Layout

```nix
# ✅ GOOD: Use theme layout values
border = {
  width = theme.border.width;
  color = theme.border.color;
  activeColor = theme.border.activeColor;
};

gaps = theme.gaps.inner;  # or .outer
rounding = theme.rounding;
```

---

## Naming Conventions

### Files and Directories

- **Files**: `lowercase-with-hyphens.nix`
  - ✅ `terminal-colors.nix`
  - ❌ `terminalColors.nix`
  - ❌ `terminal_colors.nix`

- **Directories**: `lowercase`
  - ✅ `modules/home/terminal/`
  - ❌ `modules/home/Terminal/`

### Nix Identifiers

- **Variables**: `camelCase`
  ```nix
  termColors = ...
  fontSize = ...
  ```

- **Attribute names**: `lowercase` or `snake_case` (match program's config)
  ```nix
  # Match the program's expected format
  font_size = 14;        # Kitty uses snake_case
  fontSize = 14;         # Some programs use camelCase
  ```

- **Module names**: Match directory structure
  ```nix
  modules/home/terminal/alacritty.nix  → programs.alacritty
  ```

### Host Names

- **Host directory**: `hosts/hostname/`
- **Flake output**: `nixosConfigurations.hostname`
- **Hostname value**: `vars.hostname = "hostname";`

All three must match!

---

## Documentation Standards

### Module Documentation

Every module should have:

1. **Header comment** explaining purpose
   ```nix
   # Alacritty terminal emulator configuration
   # Features: GPU acceleration, true color, Wayland native
   ```

2. **Section comments** for major groups
   ```nix
   # Font configuration
   font = { ... };

   # Window configuration
   window = { ... };
   ```

3. **Inline comments** for non-obvious settings
   ```nix
   cursor_stop_blinking_after = 0;  # Never stop blinking
   ```

### vars.nix Documentation

```nix
{
  # Basic information
  username = "yawarakatai";
  hostname = "desuwa";

  # Display configuration
  # Find monitor names with: niri msg outputs
  monitors = {
    primary = {
      name = "HDMI-A-1";          # Monitor output name
      width = 3840;               # Resolution width
      # ... more fields with descriptions
    };
  };
}
```

### README Files

- **Per-host README**: Not needed (config is self-documenting)
- **Main README.md**: Personal reference (concise)
- **docs/ directory**: Detailed guides and templates

---

## File Organization

### Directory Structure

```
lib/                    # Shared libraries (pure functions)
modules/
  system/              # NixOS modules
    base.nix           # Base configuration (shared)
    *.nix              # Specific system modules
  home/                # Home Manager modules
    themes/            # Theme definitions
    shell/             # Shell configurations
    editors/           # Editor configurations
    terminal/          # Terminal emulators
    wayland/           # Wayland-specific
    tools/             # CLI tools
hosts/
  _template/           # Template for new hosts
  hostname/            # Actual host configs
    vars.nix           # Host variables
    configuration.nix  # System config
    hardware-configuration.nix  # Hardware (auto-generated)
home/
  hostname/
    home.nix           # Home Manager config
docs/                  # Documentation
  *.md                 # Guides
  MODULE_TEMPLATE.nix  # Template
```

### Import Organization

Order imports logically:

```nix
imports = [
  # 1. Shared base (if applicable)
  ../../modules/system/base.nix

  # 2. Core system modules (alphabetically)
  ../../modules/system/audio.nix
  ../../modules/system/boot.nix
  ../../modules/system/locale.nix

  # 3. Hardware-specific modules (with comments)
  ../../modules/system/nvidia.nix  # RTX 3080
  ../../modules/system/yubikey.nix # YubiKey support
];
```

---

## Git Workflow

### Commit Messages

Follow conventional commits:

```
<type>: <subject>

<body>

<footer>
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code restructuring (no behavior change)
- `docs`: Documentation only
- `style`: Formatting, missing semi-colons, etc.
- `perf`: Performance improvement
- `test`: Adding tests
- `chore`: Maintenance tasks

**Examples**:

```
feat: add ghostty terminal emulator config

- Add ghostty.nix module with theme integration
- Use shared terminal-colors library
- Disabled by default (alacritty is active)
```

```
fix: correct yazi config for v0.3 API changes

- Change manager → mgr (deprecated)
- Change exec → run in keybindings
- Update theme section to use mgr
```

```
refactor: extract terminal colors to shared library

This eliminates duplication across alacritty, kitty, and ghostty.
Color mappings now defined once in lib/terminal-colors.nix.

Reduces code by ~260 lines across affected modules.
```

### Branch Naming

- `main` or `master`: Stable, working config
- `feature/description`: New features
- `fix/description`: Bug fixes
- `refactor/description`: Major refactoring

### Commit Granularity

- **One logical change per commit**
- ✅ GOOD: "fix: update yazi config for API v0.3"
- ❌ BAD: "fix yazi and update readme and add new module"

### Before Committing

```bash
# 1. Check flake syntax
nix flake check

# 2. Test build
nixos-rebuild build --flake .#desuwa

# 3. Preview changes (optional)
nixos-rebuild dry-build --flake .#desuwa

# 4. Commit with descriptive message
git add -A
git commit -m "type: description"
```

---

## Common Patterns

### Shared Color Scheme

```nix
# In module
let
  termColors = import ../../../lib/terminal-colors.nix { inherit theme; };
in
{
  # Use termColors.ansi.* and termColors.primary.*
}
```

### Host-Specific Values

```nix
# In vars.nix
{
  username = "yawarakatai";
  hostname = "desuwa";
  timezone = "Asia/Tokyo";
  # ... more host-specific values
}

# In module
{
  time.timeZone = vars.timezone;
  networking.hostName = vars.hostname;
}
```

### Conditional Configuration

```nix
# ✅ GOOD: Use lib.mkIf
config = lib.mkIf config.myModule.enable {
  # Configuration here
};
```

```nix
# ❌ BAD: Manual conditionals
if config.myModule.enable then {
  # Don't do this
} else { }
```

### Module Options

```nix
# Define options
options.myModule = {
  enable = lib.mkEnableOption "myModule";

  extraConfig = lib.mkOption {
    type = lib.types.str;
    default = "";
    description = "Extra configuration";
  };
};

# Use in config
config = lib.mkIf config.myModule.enable {
  # ...
};
```

### Extending Base Config

```nix
# In host configuration.nix
# Base settings are in modules/system/base.nix

# Extend with host-specific values
nix.settings = {
  # This merges with base.nix settings
  substituters = [
    "https://my-extra-cache.cachix.org"
  ];
  trusted-public-keys = [
    "my-cache-key"
  ];
};
```

---

## Anti-Patterns

### ❌ Hard-Coding Values

```nix
# BAD
background = "#000000";
font = "CommitMono Nerd Font";
monitor = "HDMI-A-1";

# GOOD
background = theme.colorScheme.base00;
font = theme.font.name;
monitor = vars.monitors.primary.name;
```

### ❌ Duplicating Code

```nix
# BAD: Same color mapping in 3 files
# alacritty.nix
colors.black = theme.colorScheme.base00;
# kitty.nix
color0 = theme.colorScheme.base00;
# ghostty.nix
palette."0" = theme.colorScheme.base00;

# GOOD: Shared library
let
  termColors = import ../../../lib/terminal-colors.nix { inherit theme; };
in
# Use termColors in all terminals
```

### ❌ Mixing Concerns

```nix
# BAD: System packages in home config
home.packages = [ pkgs.networkmanager ];

# GOOD: System packages in system config
environment.systemPackages = [ pkgs.networkmanager ];
```

### ❌ Unclear Module Boundaries

```nix
# BAD: Everything in one huge module
modules/home/all-config.nix  # 2000 lines

# GOOD: Logical separation
modules/home/shell/nushell.nix      # 150 lines
modules/home/shell/starship.nix     # 100 lines
modules/home/editors/helix.nix      # 300 lines
```

### ❌ Poor Error Messages

```nix
# BAD: Silent failures or cryptic errors
assert config.foo != null;

# GOOD: Descriptive error messages
assertions = [{
  assertion = config.foo != null;
  message = "myModule requires 'foo' to be set. Please configure it in vars.nix";
}];
```

### ❌ Imperative Scripts

```nix
# BAD: Shell scripts for configuration
system.activationScripts.setup = ''
  mkdir -p /etc/myapp
  cp ${./config.json} /etc/myapp/config.json
'';

# GOOD: Declarative configuration
environment.etc."myapp/config.json".source = ./config.json;
```

---

## Testing and Validation

### Before Pushing

1. **Syntax check**
   ```bash
   nix flake check
   ```

2. **Build test**
   ```bash
   nixos-rebuild build --flake .#desuwa
   ```

3. **Dry run** (optional, see what changes)
   ```bash
   nixos-rebuild dry-build --flake .#desuwa
   ```

### After Major Changes

1. **Test build** (creates result symlink)
   ```bash
   nixos-rebuild test --flake .#desuwa
   ```

2. **Switch** (if test successful)
   ```bash
   nixos-rebuild switch --flake .#desuwa
   ```

3. **Rollback** (if issues)
   ```bash
   nixos-rebuild switch --rollback
   ```

---

## Quick Reference

### Always Do:
- ✅ Use theme values for colors
- ✅ Use vars for host-specific values
- ✅ Import shared libraries (don't duplicate)
- ✅ Comment non-obvious settings
- ✅ Check with `nix flake check` before commit
- ✅ Test with `nd` before `ns`
- ✅ One logical change per commit
- ✅ Follow module template structure

### Never Do:
- ❌ Hard-code colors, fonts, or host-specific values
- ❌ Duplicate code across modules
- ❌ Mix system and home-manager concerns
- ❌ Commit without testing
- ❌ Use imperative scripts when declarative config exists
- ❌ Create massive monolithic modules

### When in Doubt:
1. Check existing modules for patterns
2. Refer to `docs/MODULE_TEMPLATE.nix`
3. Look at recent refactoring (REFACTORING.md)
4. Test with `nd` (dry-build) first
5. Read the error messages carefully

---

## Resources

- **This config**:
  - `docs/MODULE_TEMPLATE.nix` - Template for new modules
  - `REFACTORING.md` - Recent refactoring guide
  - `CHANGELOG.md` - Detailed changelog

- **External**:
  - [Nix Pills](https://nixos.org/guides/nix-pills/) - Learn Nix language
  - [NixOS Manual](https://nixos.org/manual/nixos/stable/)
  - [Home Manager Manual](https://nix-community.github.io/home-manager/)
  - [Nix Style Guide](https://nix.dev/contributing/documentation/style-guide)

---

**Last Updated**: After major refactoring (see CHANGELOG.md)

**Maintainer**: yawarakatai

**Status**: Living document - update as patterns evolve
