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

The configuration automatically includes/excludes modules based on hardware flags. Only enable the features your device actually has!

### Graphics Hardware
- `hasNvidia`: NVIDIA GPU with proprietary drivers
- `hasAMD`: AMD GPU (usually auto-detected, set for documentation)
- `hasIntel`: Intel integrated graphics (usually auto-detected)

### Connectivity
- `hasWifi`: WiFi adapter (enables NetworkManager WiFi support)
- `hasBluetooth`: Bluetooth adapter (enables blueman and bluetooth stack)
- `hasEthernet`: Wired ethernet (usually true for desktops)

### Input Devices
- `hasLogitechMouse`: Logitech mouse (enables logiops for button remapping)
- `hasCustomKeyboard`: Custom keyboard needing fixes (e.g., Lofree Flow Fn keys)
- `hasTouchpad`: Laptop touchpad (enables libinput with tap-to-click, gestures)
- `hasTouchscreen`: Touchscreen display

### Biometric & Security
- `hasYubikey`: YubiKey hardware key (enables GPG/SSH support)
- `hasFingerprintSensor`: Fingerprint reader (enables fprintd + PAM authentication)
- `hasTPM`: TPM chip (set for documentation/future use)

### Peripherals
- `hasPrinter`: Printer support (enables CUPS and network discovery)
- `hasScanner`: Scanner support (enables SANE, automatically included with printer module)
- `hasWebcam`: Webcam (set for documentation/future driver support)

**Important**: Set these to `false` if you don't have the hardware - unnecessary modules won't be loaded, keeping your system lean!
