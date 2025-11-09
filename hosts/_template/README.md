# New Host Template

This template helps you add a new device to your NixOS configuration.

## Steps to add a new host:

1. **Copy this template:**
   ```bash
   cp -r hosts/_template hosts/YOUR-HOSTNAME
   ```

2. **Generate hardware configuration:**
   ```bash
   nixos-generate-config --show-hardware-config > hosts/YOUR-HOSTNAME/hardware-configuration.nix
   ```

3. **Edit vars.nix:**
   - Update all the values in `hosts/YOUR-HOSTNAME/vars.nix` according to your device
   - Configure display settings, timezone, storage, and other preferences

4. **Edit configuration.nix:**
   - **Uncomment the hardware modules you need** in the `imports` section
   - Generate password hash: `mkpasswd -m sha-512`
   - Review and adjust any host-specific settings

5. **Create home configuration:**
   ```bash
   mkdir -p home/YOUR-HOSTNAME
   cp home/desuwa/home.nix home/YOUR-HOSTNAME/home.nix
   ```
   - Customize as needed for this device

6. **Add to flake.nix:**
   Edit `flake.nix` and add your host to `nixosConfigurations`:
   ```nix
   nixosConfigurations = {
     desuwa = mkSystem "desuwa";
     YOUR-HOSTNAME = mkSystem "YOUR-HOSTNAME";
   };
   ```

7. **Build and switch:**
   ```bash
   sudo nixos-rebuild switch --flake .#YOUR-HOSTNAME
   ```

## Available Hardware Modules

In `configuration.nix`, uncomment the modules you need in the `imports` section:

### Core Modules (usually always needed)
- `boot.nix` - Boot loader configuration
- `networking.nix` - NetworkManager, firewall, DNS
- `locale.nix` - Timezone, locale, keyboard layout
- `audio.nix` - PipeWire audio
- `zram.nix` - Compressed swap
- `storage.nix` - Disk/filesystem management
- `rebuild-helper.nix` - Convenient rebuild commands (nd, ns, nus, etc.)
- `wayland.nix` - Wayland compositor support
- `niri-override.nix` - Niri window manager tweaks

### Hardware-Specific Modules (import only what you need)
- `nvidia.nix` - NVIDIA GPU with proprietary drivers
- `bluetooth.nix` - Bluetooth stack with blueman
- `touchpad.nix` - Laptop touchpad with gestures
- `fingerprint.nix` - Fingerprint reader (fprintd + PAM)
- `yubikey.nix` - YubiKey support for GPG/SSH
- `logiops.nix` - Logitech mouse button remapping
- `keyboard.nix` - Custom keyboard fixes (e.g., Lofree Flow)
- `printer.nix` - Printer and scanner support (CUPS + SANE)

**Key Principle**: Only import the modules your device actually needs. This keeps your configuration clean and explicit!
