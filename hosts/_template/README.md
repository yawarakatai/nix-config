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
   - Set hardware flags (`hasNvidia`, `hasLogitechMouse`, etc.) based on what's available
   - Configure display settings, timezone, and other preferences

4. **Copy and customize configuration.nix:**
   ```bash
   cp hosts/desuwa/configuration.nix hosts/YOUR-HOSTNAME/configuration.nix
   ```
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

## Feature Flags in vars.nix

The configuration automatically includes/excludes modules based on these flags:

- `hasNvidia`: Includes NVIDIA driver configuration
- `hasLogitechMouse`: Includes logiops (Logitech mouse button mapping)
- `hasCustomKeyboard`: Includes custom keyboard fixes
- `hasYubikey`: Includes Yubikey support
- `hasBluetooth`: Enables Bluetooth support

Set these to `false` if you don't have the hardware - the modules won't be loaded!
