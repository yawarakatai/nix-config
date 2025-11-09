# Configuration Refactoring Guide

This document describes the recent refactoring of the nix-config repository to eliminate duplication, improve flexibility, and make the configuration more maintainable.

## Key Improvements

### 1. Shared Terminal Color Scheme (`lib/terminal-colors.nix`)

**Problem:** Terminal color mapping was duplicated across alacritty, kitty, and ghostty modules (90+ lines of duplication).

**Solution:** Created a shared color scheme generator that maps Base16 colors to ANSI terminal colors in one place.

**Usage:**
```nix
let
  termColors = import ../../../lib/terminal-colors.nix { inherit theme; };
in
{
  # Use termColors.ansi.* for ANSI colors
  # Use termColors.primary.* for background, foreground, cursor, selection
}
```

**Benefits:**
- Change terminal colors once, applies to all terminals
- Reduces code from ~40 lines per terminal to ~5 lines
- Easier to maintain color consistency

### 2. Shared Base System Configuration (`modules/system/base.nix`)

**Problem:** Core system settings were duplicated between `hosts/desuwa/configuration.nix` and `hosts/_template/configuration.nix` (100+ lines of duplication).

**Solution:** Created a shared base module containing:
- Essential system packages (vim, git, wget, curl, etc.)
- User configuration defaults (groups, shell)
- Nix daemon settings (flakes, gc, optimisation, caches)
- Common services (greetd, niri, gvfs, direnv, dconf)
- XWayland and unfree package settings

**Usage:**
```nix
imports = [
  ../../modules/system/base.nix
  # other modules...
];
```

**Benefits:**
- Host configurations reduced from 145 lines to ~50 lines
- Changes to base settings apply to all hosts automatically
- New hosts only need to specify what's unique
- Template is much cleaner and easier to use

### 3. Structured Monitor Configuration

**Problem:** Monitor settings were hard-coded in niri settings, with only monitor names in vars.

**Solution:** Extended vars.nix to include complete monitor configuration:
```nix
monitors = {
  primary = {
    name = "HDMI-A-1";
    width = 3840;
    height = 2160;
    refresh = 143.999;
    scale = 1.0;
    position = { x = 0; y = 0; };
    vrr = true;
  };
  # Easy to add secondary monitors
};
```

**Benefits:**
- All monitor settings in one place (vars.nix)
- Easy to add multi-monitor support
- No hard-coded values in module files
- Monitor config can be per-host

### 4. Standardized Module Structure

**Before:**
- Inconsistent enable patterns (comments vs enable = false)
- No module options for customization
- Hard to configure modules without editing them

**After:**
- Clear module structure with options
- Helper functions for creating options (`lib/module-options.nix`)
- Template for creating new modules

## Configuration Architecture

```
nix-config/
├── lib/                          # Shared libraries and helpers
│   ├── terminal-colors.nix       # Shared terminal color scheme
│   └── module-options.nix        # Module option helpers
├── modules/
│   ├── system/
│   │   ├── base.nix              # Shared base configuration (NEW)
│   │   └── ...                   # Other system modules
│   └── home/
│       ├── terminal/             # All use shared colors (UPDATED)
│       │   ├── alacritty.nix
│       │   ├── kitty.nix
│       │   └── ghostty.nix
│       └── ...
└── hosts/
    ├── desuwa/
    │   ├── vars.nix              # Extended with monitor config (UPDATED)
    │   └── configuration.nix     # Simplified (UPDATED)
    └── _template/
        └── configuration.nix     # Much cleaner (UPDATED)
```

## Migration Guide

### For Existing Hosts

If you have existing host configurations:

1. Add base.nix import at the top of your imports list:
   ```nix
   imports = [
     ../../modules/system/base.nix
     # ...other imports
   ];
   ```

2. Remove duplicated settings (they're now in base.nix):
   - environment.systemPackages (base tools)
   - users.mutableUsers and basic user config
   - nix.settings (experimental-features, caches, etc.)
   - nix.gc and nix.optimise
   - services.greetd
   - programs.niri, direnv, dconf, xwayland
   - nixpkgs.config.allowUnfree

3. Keep only host-specific settings:
   - networking.hostName
   - users.users.${username}.hashedPassword
   - Host-specific hardware modules
   - Additional caches/substituters (they extend base.nix)

4. Update vars.nix with structured monitor config:
   ```nix
   monitors = {
     primary = {
       name = "HDMI-A-1";
       width = 1920;
       height = 1080;
       refresh = 60.0;
       scale = 1.0;
       position = { x = 0; y = 0; };
       vrr = false;
     };
   };
   ```

### For New Hosts

1. Copy `hosts/_template/` to `hosts/your-hostname/`
2. Create vars.nix with your settings
3. Edit configuration.nix to:
   - Set hostname
   - Set password hash
   - Uncomment hardware modules you need
4. That's it! All base config is inherited

## Best Practices

### Adding New Modules

1. Use the module option helpers:
   ```nix
   { config, lib, pkgs, ... }:
   let
     opts = import ../../lib/module-options.nix { inherit lib; };
   in
   {
     options.myModule = {
       enable = opts.mkEnableOption "myModule" "my awesome module";
       # ...
     };
   }
   ```

2. Use theme values instead of hard-coding colors:
   ```nix
   # Bad
   color = "#ff0000";

   # Good
   color = theme.semantic.error;
   ```

3. Use vars for host-specific values:
   ```nix
   # Bad
   timezone = "Asia/Tokyo";

   # Good
   timezone = vars.timezone;
   ```

### Terminal Configuration

All terminal emulators now use the shared color scheme. To modify terminal colors:

1. Edit `modules/home/themes/night-neon.nix` (or your theme)
2. Colors automatically apply to all terminals
3. No need to edit individual terminal modules

### Adding New Caches

Host-specific caches extend the base caches:

```nix
# In hosts/your-host/configuration.nix
nix.settings = {
  substituters = [
    "https://your-cache.cachix.org"  # Adds to base caches
  ];
  trusted-public-keys = [
    "your-cache-key"
  ];
};
```

## Statistics

### Code Reduction

- **Terminal modules:** Reduced from ~115 lines each to ~75 lines each (35% reduction)
- **Host configurations:** Reduced from ~145 lines to ~50 lines (65% reduction)
- **Template:** Reduced from ~140 lines to ~42 lines (70% reduction)

### Duplication Eliminated

- Terminal color mappings: 3 copies → 1 shared library
- Nix daemon config: 2 copies → 1 base module
- System packages: 2 copies → 1 base module
- User defaults: 2 copies → 1 base module
- Service configs: 2 copies → 1 base module

### Flexibility Gained

- Monitor configuration: Hard-coded → Per-host vars
- Color schemes: 3 places → 1 theme file
- Base configuration: Duplicated → Inherited
- Host setup: Complex → Simple template

## Future Improvements

Potential areas for further enhancement:

1. **Host Profiles:** Create profiles for laptop/desktop/server with appropriate defaults
2. **Hardware Detection:** Auto-enable modules based on detected hardware
3. **Theme Switching:** Make it easy to switch between themes
4. **Module Categories:** Group related modules with category-level options
5. **Validation:** Add checks for required vars and common mistakes
6. **Multiple Monitors:** Add helper for easy multi-monitor configuration

## Questions?

Refer to:
- `lib/terminal-colors.nix` - Terminal color scheme generator
- `modules/system/base.nix` - Shared base configuration
- `hosts/_template/` - Clean template for new hosts
- `hosts/desuwa/` - Example of refactored host
