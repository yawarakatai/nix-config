# yawarakatai's NixOS Config

My personal NixOS configuration using flakes and home-manager.

## System: desuwa

- **CPU**: AMD Ryzen 7 3700X (16 threads)
- **RAM**: 16GB + zram
- **GPU**: NVIDIA RTX 3080
- **Storage**: 2TB NVMe (Btrfs)
- **Display**: 4K 144Hz @ HDMI-A-1
- **OS**: NixOS 25.05

## Setup

- **Compositor**: niri (Wayland)
- **Terminal**: Alacritty
- **Launcher**: Vicinae
- **Bar**: waybar
- **Shell**: nushell + starship + zoxide + atuin
- **Editor**: Helix (primary), VSCode
- **File Manager**: yazi (TUI), Nautilus (GUI)
- **Browser**: Firefox
- **Input**: fcitx5 + mozc (Japanese)
- **Theme**: Neon Night (pure black + vibrant neon accents)

## Quick Commands

### System Management

```bash
# Rebuild (using helper commands from modules/system/rebuild-helper.nix)
nd   # dry-build (preview)
nt   # test (temporary)
ns   # switch (apply now + bootloader)
nb   # boot (apply on next boot)
nus  # update flake + switch
nfc  # check flake
ngc  # garbage collect
```

### Manual Rebuild

```bash
# System
sudo nixos-rebuild switch --flake .#desuwa

# Home Manager
home-manager switch --flake .#desuwa

# Both with update
nix flake update && sudo nixos-rebuild switch --flake .#desuwa
```

## Structure

```
.
├── lib/                      # Shared libraries
│   ├── terminal-colors.nix   # Shared terminal color scheme
│   └── module-options.nix    # Module option helpers
├── modules/
│   ├── system/
│   │   ├── base.nix          # Base config (shared across hosts)
│   │   ├── nvidia.nix        # RTX 3080
│   │   ├── yubikey.nix       # YubiKey GPG/SSH
│   │   ├── logiops.nix       # Logitech MX Master 3S
│   │   └── lofreeflowlite.nix # Lofree Flow keyboard
│   └── home/
│       ├── themes/night-neon.nix  # Color scheme
│       ├── shell/            # nushell, starship, zoxide, atuin
│       ├── editors/          # helix, vscode
│       ├── terminal/         # alacritty
│       ├── wayland/          # niri, waybar, mako, vicinae
│       └── tools/            # yazi, lazygit, cli-tools, glow
├── hosts/desuwa/
│   ├── vars.nix              # Host-specific variables
│   ├── configuration.nix     # System config
│   └── hardware-configuration.nix
├── home/desuwa/home.nix      # Home Manager config
└── docs/
    ├── REFACTORING.md        # Recent refactoring guide
    ├── CODING_GUIDE.md       # Coding conventions (see this!)
    └── MODULE_TEMPLATE.nix   # Template for new modules
```

## Theme Customization

All colors defined in `modules/home/themes/night-neon.nix`:
- Edit once, applies to all programs
- Uses Base16 color scheme
- Semantic mappings for consistency

## Storage Layout (Btrfs)

```
@ -> /                  # Root
@home -> /home          # User files
@nix -> /nix            # Nix store
@log -> /var/log        # Logs (can restore without affecting system)
@cache -> /var/cache    # Cache (can delete without issues)
@tmp -> /tmp            # Temporary files
```

## Important Files

- **vars.nix**: Monitor config, timezone, locale, git info
- **base.nix**: Common system settings (packages, nix config, services)
- **night-neon.nix**: All colors and theme settings
- **home.nix**: User packages and personal config
- **CODING_GUIDE.md**: Conventions and best practices (READ THIS!)

## Adding Software

### User Packages (home.nix)
```nix
home.packages = with pkgs; [
  your-package
];
```

### System Packages (configuration.nix or modules)
```nix
environment.systemPackages = with pkgs; [
  your-package
];
```

## Hardware-Specific

This host has:
- NVIDIA drivers (proprietary)
- YubiKey support
- Logitech mouse custom config
- Custom keyboard (Lofree Flow)

## Notes to Self

- Always check `nfc` before committing
- Use `nd` to preview changes before `ns`
- Terminal colors: Edit `night-neon.nix`, not individual terminal configs
- Monitor settings: Edit `vars.nix`, not `niri/settings.nix`
- New modules: Follow template in `docs/MODULE_TEMPLATE.nix`
- Coding style: See `docs/CODING_GUIDE.md`
- Recent refactoring details: See `REFACTORING.md` and `CHANGELOG.md`

## Troubleshooting

```bash
# Check syntax
nix flake check

# Detailed error trace
sudo nixos-rebuild switch --flake .#desuwa --show-trace

# Rollback
sudo nixos-rebuild switch --rollback

# Clean old generations
ngc  # or: sudo nix-collect-garbage -d
```

## Useful Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Niri Wiki](https://github.com/YaLTeR/niri/wiki)
