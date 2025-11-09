# Configuration Refactoring Changelog

## Summary

Major refactoring to eliminate code duplication, improve flexibility, and make the configuration more maintainable and extensible.

## Changes Made

### New Files Created

1. **`lib/terminal-colors.nix`**
   - Shared terminal color scheme generator
   - Eliminates duplication across alacritty, kitty, and ghostty
   - Maps Base16 colors to ANSI terminal colors
   - Single source of truth for terminal color configuration

2. **`modules/system/base.nix`**
   - Shared base system configuration module
   - Contains common settings used across all hosts:
     - Essential system packages (vim, git, wget, curl, etc.)
     - Default user configuration
     - Nix daemon settings (flakes, gc, optimization, caches)
     - Common services (greetd, niri, gvfs, direnv, dconf)
     - XWayland and unfree package settings

3. **`lib/module-options.nix`**
   - Helper functions for creating module options
   - Standardizes module configuration patterns
   - Makes it easier to create configurable modules

4. **`REFACTORING.md`**
   - Comprehensive guide explaining the refactoring
   - Migration guide for existing hosts
   - Best practices for adding new modules
   - Architecture overview

5. **`docs/MODULE_TEMPLATE.nix`**
   - Template for creating new modules
   - Shows best practices for theme integration
   - Includes examples and checklists

6. **`CHANGELOG.md`** (this file)
   - Documents all changes made during refactoring

### Modified Files

#### Host Configurations

**`hosts/desuwa/configuration.nix`**
- **Before:** 145 lines
- **After:** 54 lines (63% reduction)
- Now imports `base.nix` for common settings
- Only contains host-specific configuration:
  - Hostname
  - User password hash
  - Hardware-specific modules
  - Additional caches (Vicinae)

**`hosts/_template/configuration.nix`**
- **Before:** 140 lines
- **After:** 42 lines (70% reduction)
- Much simpler template for new hosts
- Clear comments on what needs to be configured
- All common settings inherited from base.nix

**`hosts/desuwa/vars.nix`**
- Extended monitor configuration from simple list to structured config:
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
  };
  ```
- Enables easy multi-monitor setup
- All monitor settings in one place

**`hosts/_template/vars.nix`**
- Updated with new monitor configuration structure
- Includes helpful comments and examples
- Shows how to configure multiple monitors

#### Terminal Modules

**`modules/home/terminal/alacritty.nix`**
- **Before:** 115 lines with duplicated color mapping
- **After:** 75 lines using shared color scheme
- Imports and uses `lib/terminal-colors.nix`
- 35% code reduction

**`modules/home/terminal/kitty.nix`**
- **Before:** 79 lines with duplicated color mapping
- **After:** 65 lines using shared color scheme
- Imports and uses `lib/terminal-colors.nix`
- 18% code reduction

**`modules/home/terminal/ghostty.nix`**
- **Before:** 76 lines with duplicated color mapping
- **After:** 59 lines using shared color scheme
- Imports and uses `lib/terminal-colors.nix`
- 22% code reduction

#### Wayland Configuration

**`modules/home/wayland/niri/settings.nix`**
- Removed hard-coded monitor settings
- Now uses structured monitor config from vars:
  ```nix
  outputs = {
    "${vars.monitors.primary.name}" = {
      mode = {
        width = vars.monitors.primary.width;
        height = vars.monitors.primary.height;
        refresh = vars.monitors.primary.refresh;
      };
      variable-refresh-rate = if vars.monitors.primary.vrr then "on-demand" else "off";
      scale = vars.monitors.primary.scale;
      position = vars.monitors.primary.position;
    };
  };
  ```

## Code Metrics

### Lines of Code Reduced

| File | Before | After | Reduction |
|------|--------|-------|-----------|
| hosts/desuwa/configuration.nix | 145 | 54 | 63% |
| hosts/_template/configuration.nix | 140 | 42 | 70% |
| modules/home/terminal/alacritty.nix | 115 | 75 | 35% |
| modules/home/terminal/kitty.nix | 79 | 65 | 18% |
| modules/home/terminal/ghostty.nix | 76 | 59 | 22% |
| **Total** | **555** | **295** | **47%** |

### Duplication Eliminated

- **Terminal color mappings:** 3 copies → 1 shared library
- **Nix daemon configuration:** 2 copies → 1 base module
- **System packages list:** 2 copies → 1 base module
- **User configuration:** 2 copies → 1 base module
- **Service configurations:** 2 copies → 1 base module
- **Monitor settings:** Hard-coded → Structured vars

### New Infrastructure Added

- 2 shared libraries (`lib/terminal-colors.nix`, `lib/module-options.nix`)
- 1 base module (`modules/system/base.nix`)
- 2 documentation files (`REFACTORING.md`, `CHANGELOG.md`)
- 1 module template (`docs/MODULE_TEMPLATE.nix`)

## Benefits

### For Maintainability

1. **Single Source of Truth:** Color schemes, system settings, and common configs defined once
2. **Easier Updates:** Change terminal colors once, applies to all terminals
3. **Reduced Duplication:** ~260 lines of duplicated code eliminated
4. **Better Organization:** Clear separation between shared and host-specific config

### For Extensibility

1. **Easy Multi-Monitor:** Structured monitor config supports multiple displays
2. **Simple Host Setup:** New hosts only need ~40 lines of config
3. **Module Template:** Standard pattern for creating new modules
4. **Option Helpers:** Easy to add configurable options to modules

### For Flexibility

1. **Per-Host Customization:** Easy to override base settings per host
2. **Theme Integration:** All modules consistently use theme values
3. **Structured Data:** Monitor config, font config properly structured
4. **Host Profiles:** Foundation for creating laptop/desktop/server profiles

## Migration Notes

### For Existing Hosts

1. Import `../../modules/system/base.nix` at the top of imports
2. Remove duplicated settings (now in base.nix)
3. Keep only host-specific settings
4. Update vars.nix with structured monitor config

### For New Hosts

1. Copy `hosts/_template/` directory
2. Fill in vars.nix with your settings
3. Set hostname and password in configuration.nix
4. Uncomment needed hardware modules
5. Done! (~5 minutes vs ~30 minutes before)

## Breaking Changes

### Monitor Configuration

Old format:
```nix
monitors = [ "HDMI-A-1" ];
```

New format:
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
};
```

**Action Required:** Update vars.nix in all hosts with new monitor structure.

## Testing

To test the refactored configuration:

```bash
# Check flake syntax
nix flake check

# Build configuration (dry run)
nixos-rebuild build --flake .#desuwa

# Build home-manager (dry run)
home-manager build --flake .#desuwa

# Apply system configuration
sudo nixos-rebuild switch --flake .#desuwa

# Apply home-manager configuration
home-manager switch --flake .#desuwa
```

## Future Improvements

Potential enhancements for future iterations:

1. **Host Profiles:** Create reusable profiles (laptop, desktop, server)
2. **Hardware Detection:** Auto-enable modules based on detected hardware
3. **Theme Variants:** Easy switching between light/dark/custom themes
4. **Multi-Monitor Helpers:** Functions to simplify multi-monitor setup
5. **Module Categories:** Group related modules with category options
6. **Validation Functions:** Check for required vars and common mistakes
7. **Conditional Imports:** Auto-import modules based on hardware flags

## Acknowledgments

This refactoring follows NixOS best practices and patterns from:
- NixOS module system documentation
- Home-Manager module patterns
- Base16 color scheme standard
- Community flake templates
