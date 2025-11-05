# NixOS Configuration

A modern, modular NixOS configuration with flakes featuring a black-themed "Neon Night" aesthetic.

## 🎨 Theme: Neon Night

A minimal dark theme with pure black background and vibrant neon accents:
- **Background**: Pure black (#000000)
- **Foreground**: Soft white (#cccccc)
- **Accents**: Lime green, cyan, purple, yellow, orange, cherry red

## 🖥️ System Information

- **Hostname**: desuwa
- **Username**: yawarakatai
- **CPU**: AMD Ryzen 7 3700X (16 threads)
- **RAM**: 16GB + zram
- **GPU**: NVIDIA RTX 3080
- **Storage**: 2TB NVMe SSD (Btrfs with subvolumes)
- **Display**: 4K 144Hz monitor

## 📦 Software Stack

### Window Manager & Desktop
- **Compositor**: niri (Wayland)
- **Terminal**: Ghostty
- **Launcher**: tofi
- **Status Bar**: waybar
- **Notifications**: mako

### Development
- **Shell**: nushell + starship
- **Editors**: Helix, VSCode
- **Version Control**: lazygit, delta
- **Environment**: direnv + nix develop

### Tools
- **File Manager**: yazi (TUI), nautilus (GUI)
- **Browser**: Firefox
- **CLI Utilities**: eza, bat, fd, ripgrep, bottom, fzf

## 📁 Directory Structure

```
nix-config/
├── flake.nix                 # Main entry point
├── flake.lock                # Dependency lock file
├── hosts/                    # Host-specific configurations
│   └── desuwa/
│       ├── vars.nix          # Host variables
│       ├── configuration.nix # System configuration
│       └── hardware-configuration.nix
├── modules/                  # Reusable modules
│   ├── system/              # System-level modules
│   │   ├── boot.nix
│   │   ├── nvidia.nix
│   │   ├── networking.nix
│   │   ├── locale.nix
│   │   ├── audio.nix
│   │   ├── zram.nix
│   │   ├── storage.nix
│   │   ├── yubikey.nix
│   │   └── rebuild-helper.nix
│   └── home/                # Home Manager modules
│       ├── theme.nix        # Unified theme
│       ├── shell/           # Shell configurations
│       ├── editors/         # Editor configurations
│       ├── terminal/        # Terminal configurations
│       ├── wayland/         # Wayland-specific configs
│       └── tools/           # Tool configurations
├── home/                     # User configurations
│   └── yawarakatai/
│       └── home.nix
├── secrets/                  # Encrypted secrets (sops-nix)
└── README.md
```

## 🚀 Quick Start

See [SETUP.md](SETUP.md) for detailed installation instructions.

### TL;DR

```bash
# 1. Copy to home directory
cp -r nix-config ~/.config/

# 2. Generate hardware config
sudo nixos-generate-config --show-hardware-config > ~/.config/nix-config/hosts/desuwa/hardware-configuration.nix

# 3. Generate password hash
nix-shell -p mkpasswd --run "mkpasswd -m sha-512"
# Copy the output and update hosts/desuwa/configuration.nix

# 4. Build and switch
cd ~/.config/nix-config
sudo nixos-rebuild switch --flake .#desuwa
```

## 🔧 Configuration Highlights

### Theme Management

All colors are centralized in `modules/home/theme.nix`. Change colors once, update everywhere.

```nix
# modules/home/theme.nix
colorScheme = {
  base00 = "#000000";  # Background
  base0C = "#00ffff";  # Cyan - used across all apps
  # ...
};
```

### Rebuild Helpers

Convenient commands for system management:

- `nos` - nixos-rebuild switch
- `nob` - nixos-rebuild boot
- `not` - nixos-rebuild test
- `nou` - update flake and rebuild
- `noc` - check flake
- `nog` - garbage collect

### Storage Layout

Btrfs subvolumes for flexibility:

```
@ -> /
@home -> /home
@nix -> /nix
@log -> /var/log
@cache -> /var/cache
@tmp -> /tmp
```

### Memory Management

- **zram**: 50% of RAM for compressed swap
- **zswap**: Disabled (not needed with zram)
- **No swap partition**: Pure zram approach

## 🎯 Key Features

1. **Flake-based**: Reproducible and pinned dependencies
2. **Home Manager**: Declarative user environment
3. **Modular**: Easy to add/remove components
4. **Theme-first**: Unified color scheme across all applications
5. **YubiKey Ready**: GPG and SSH support configured
6. **Developer-friendly**: direnv + nix develop workflow
7. **Performance**: Optimized for Ryzen + NVIDIA + NVMe

## 🔐 Security

- Root login disabled
- Firewall enabled by default
- YubiKey support for GPG/SSH
- sops-nix ready for secrets management

## 📝 Customization

### Adding a New Host

```bash
# 1. Create host directory
mkdir -p hosts/nanodesu

# 2. Create vars.nix
cp hosts/desuwa/vars.nix hosts/nanodesu/vars.nix
# Edit vars.nix

# 3. Create configuration.nix
cp hosts/desuwa/configuration.nix hosts/nanodesu/
# Edit as needed

# 4. Generate hardware config
sudo nixos-generate-config --show-hardware-config > hosts/nanodesu/hardware-configuration.nix

# 5. Add to flake.nix
# nixosConfigurations.nanodesu = mkSystem "nanodesu";
```

### Changing Theme Colors

Edit `modules/home/theme.nix` and rebuild. All applications will update automatically.

### Adding New Software

For user-level software, edit `home/yawarakatai/home.nix`:

```nix
home.packages = with pkgs; [
  neovim
  # Add your packages here
];
```

For system-level software, edit `hosts/desuwa/configuration.nix`.

## 🐛 Troubleshooting

### Build fails

```bash
# Check flake
nix flake check

# Show detailed trace
nixos-rebuild switch --flake .#desuwa --show-trace
```

### Rollback

```bash
# Boot into previous generation from GRUB menu
# Or:
sudo nixos-rebuild switch --rollback
```

### Clean up

```bash
# Manual garbage collection
nog
# Or:
sudo nix-collect-garbage -d
nix-store --optimise
```

## 📚 Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Dev](https://nix.dev/)
- [NixOS Wiki](https://nixos.wiki/)

## 📄 License

This configuration is free to use and modify. No warranty provided.

## 🙏 Credits

Inspired by the NixOS community and various dotfiles repositories.
