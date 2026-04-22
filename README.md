# Machine Setup & Reinstall Guide

This guide covers adding a new host to the flake and performing a fresh NixOS install or reinstall.

## 1. Add the New Host

> Skip to [Section 3](#3-install-nixos) if reinstalling an existing host.

### 1.1 Create host directory

```
hosts/
└── <hostname>/
    ├── default.nix
    └── home/
        └── default.nix
```

### 1.2 Find the disk ID

```bash
ls /dev/disk/by-id/
```

### 1.3 `hardware-configuration.nix`

Generate on the target machine after booting the NixOS ISO:

```bash
nixos-generate-config --no-filesystems --root /mnt
cat /mnt/etc/nixos/hardware-configuration.nix
```

Copy the output into `hosts/<hostname>/hardware-configuration.nix`.

### 1.4 `default.nix`

Minimal example for a desktop host with LUKS + lanzaboote:

```nix
{ lib, pkgs, ... }:
{
  imports = [
    (import ../../modules/system/storage/disko-btrfs-luks.nix {
      device = "/dev/disk/by-id/DISK_ID";
    })
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "50%";
  };

  # Disable lanzaboote for initial install.
  # Enable after Secure Boot keys are enrolled (Section 4).
  boot.lanzaboote = {
    enable = false;
    pkiBundle = "/etc/secureboot";
  };

  # LUKS + TPM2 (PCR7 binds to Secure Boot state)
  boot.initrd.luks.devices."cryptroot" = {
    crypttabExtraOpts = [ "tpm2-device=auto" "tpm2-pcrs=7" ];
  };

  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true;

  environment.systemPackages = with pkgs; [ sbctl ];

  my.system.monitors.primary = {
    name = "DP-1";
    width = 1920;
    height = 1080;
    refresh = 60.0;
  };

  system.stateVersion = "25.05";
}
```

### 1.5 `home/default.nix`

```nix
{ osConfig, ... }:
{
  imports = [
    ../../../modules/home/profiles/desktop.nix
  ];

  home.username = osConfig.my.user.name;
  home.homeDirectory = "/home/${osConfig.my.user.name}";
  home.stateVersion = "25.05";
}
```

### 1.6 Register in `nix/nixos.nix`

Add to `nixosConfigurations`:

```nix
<hostname> = mkSystem {
  hostname = "<hostname>";
  system = "x86_64-linux";  # or "aarch64-linux"
  extraModules = baseModules ++ secretModules ++ desktopModules;
};
```

Use `serverModules` instead of `desktopModules` for headless servers.

---

## 2. Secrets (agenix-rekey)

> Skip to [Section 3](#3-install-nixos) if reinstalling and secrets are already rekeyed.

### 2.1 Get the host SSH public key

**Important:** The host key must be obtained and rekeyed *before* running nixos-anywhere.
If the key changes after install, agenix will fail to decrypt secrets on first boot.

Boot the NixOS ISO on the target machine, then:

```bash
ssh root@<target-ip> "ssh-keygen -A && cat /etc/ssh/ssh_host_ed25519_key.pub"
```

### 2.2 Add to `secrets/keys.nix`

```nix
hosts = {
  # ... existing hosts ...
  <hostname> = "ssh-ed25519 AAAA... root@<hostname>";
};
```

### 2.3 Add the new host to `secrets/secrets.nix`

For any secrets the new host needs (e.g. `user-password.age`), add `keys.hosts.<hostname>` to its `publicKeys` list.

### 2.4 Rekey secrets

From the flake root (requires YubiKey):

```bash
nix run .#agenix-rekey -- rekey
```

Commit the rekeyed secrets in `secrets/rekeyed/<hostname>/`.

### 2.5 Prepare host key for nixos-anywhere

Copy the ISO host key locally so nixos-anywhere can pass it to the target:

```bash
mkdir -p /tmp/<hostname>/etc/ssh/
scp root@<target-ip>:/etc/ssh/ssh_host_ed25519_key \
    /tmp/<hostname>/etc/ssh/
scp root@<target-ip>:/etc/ssh/ssh_host_ed25519_key.pub \
    /tmp/<hostname>/etc/ssh/
```

---

## 3. Install NixOS

### 3.1 Boot the NixOS ISO

Download from [nixos.org](https://nixos.org/download) and boot the target machine.

### 3.2 Connect to the network

```bash
# Wi-Fi
iwctl station wlan0 connect <SSID>

# Or
nmtui
```

### 3.3 Enable SSH (for remote install)

```bash
passwd nixos
systemctl start sshd
ip a  # note the IP
```

### 3.4 Install via nixos-anywhere (recommended)

```bash
nix run github:nix-community/nixos-anywhere -- \
  --flake .#<hostname> \
  --extra-files /tmp/<hostname> \
  root@<target-ip>
```

You will be prompted to set a LUKS password during install.
**Keep this password as a recovery key even after TPM2 is configured.**

### 3.5 Local install from ISO (alternative)

`disko-install` handles partitioning, formatting, and installation in one step, but may fail
with OOM on hosts with large dependencies (e.g. NVIDIA). Use the two-step method instead:

```bash
# Step 1: Partition and mount
sudo nix --experimental-features "nix-command flakes" run \
  github:nix-community/disko -- \
  --mode disko --flake .#<hostname>

# Step 2: Redirect nix store to NVMe to avoid RAM exhaustion
mount --bind /mnt/nix/store /nix/store

# Step 3: Install
sudo nixos-install --flake .#<hostname> --no-root-passwd
```

### 3.6 Initial boot

```bash
reboot
```

On first boot, LUKS must be unlocked manually with the password (TPM2 not yet configured).

---

## 4. Secure Boot Setup (lanzaboote)

lanzaboote wraps systemd-boot and signs Unified Kernel Images (UKIs) to enable Secure Boot.
**Follow this section in order. Key mismatches will make the system unbootable.**

### 4.1 Enter Setup Mode

In UEFI settings:
1. Secure Boot → **Disabled**
2. Reset to Setup Mode (or Clear Secure Boot Keys)
3. Save & Exit, boot into NixOS

### 4.2 Generate Secure Boot keys

```bash
# Verify Setup Mode is active
sbctl status  # Setup Mode: Enabled

# Generate keys — run this exactly once
sbctl create-keys
```

**Warning:** Running `sbctl create-keys` more than once generates a different key.
If the UEFI already has the old key enrolled, new signatures will be rejected.

### 4.3 Enable lanzaboote and rebuild

Edit `hosts/<hostname>/default.nix`:

```nix
boot.lanzaboote = {
  enable = true;  # was false
  pkiBundle = "/etc/secureboot";
};
```

```bash
nh os switch
```

### 4.4 Sign boot files

```bash
# Check signing status
sbctl verify

# Sign any unsigned files
find /boot/EFI -name "*.efi" | xargs -I{} sbctl sign -s {}
```

### 4.5 Enroll keys into UEFI

EFI variables are immutable by default; remove the flag before enrolling:

```bash
chattr -i /sys/firmware/efi/efivars/KEK-*
chattr -i /sys/firmware/efi/efivars/db-*
sbctl enroll-keys -m  # -m includes Microsoft keys for firmware compatibility
```

### 4.6 Enable Secure Boot

In UEFI settings, set Secure Boot → **Enabled**, then reboot.

```bash
# Confirm after boot
sbctl status  # Secure Boot: Enabled
```

### 4.7 Verify key consistency

Confirm the enrolled key matches the current signing key:

```bash
# SHA1 of the key enrolled in UEFI
mokutil --db | grep "SHA1 Fingerprint" | head -1

# SHA1 of the current db.pem
openssl x509 -in /etc/secureboot/keys/db/db.pem -noout -fingerprint -sha1
```

**If they do not match:** Re-enter Setup Mode in UEFI and re-run `sbctl enroll-keys -m`.

---

## 5. TPM2 Setup (passwordless LUKS unlock)

Run this section only after Secure Boot is confirmed working (Section 4).
PCR7 binds the TPM2 seal to the Secure Boot state, so changing Secure Boot keys requires re-enrollment.

### 5.1 Verify TPM2 is available

```bash
systemd-cryptenroll --tpm2-device=list
```

### 5.2 Enroll TPM2

```bash
systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 /dev/nvme0n1p2
```

### 5.3 Verify passwordless unlock

```bash
reboot
# LUKS should unlock automatically without a password prompt
```

### 5.4 Re-enrollment (when required)

Re-enroll TPM2 after any of the following:
- Re-generating Secure Boot keys (`sbctl create-keys`)
- Re-enrolling UEFI keys (`sbctl enroll-keys`)
- Resetting Secure Boot in UEFI (Reset to Setup Mode)

```bash
# Remove old TPM2 slot
systemd-cryptenroll --wipe-slot=tpm2 /dev/nvme0n1p2

# Re-enroll
systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 /dev/nvme0n1p2
```

---

## 6. Ongoing Rebuilds

```bash
# Rebuild and switch
nh os switch

# Update flake inputs
nix flake update

# Garbage collection (runs automatically via nh clean)
nh clean all
```

### If boot files are unsigned after rebuild

lanzaboote should sign new UKIs automatically. If `sbctl verify` shows unsigned files:

```bash
find /boot/EFI -name "*.efi" | xargs -I{} sbctl sign -s {}
```

---

## Reference: Host Overview

| Host       | Type     | Arch          | Notes                                       |
|------------|----------|---------------|---------------------------------------------|
| `desuwa`   | Desktop  | x86_64-linux  | NVIDIA RTX 3080                             |
| `desuno`   | Desktop  | x86_64-linux  | Radeon RX 590                               |
| `nanodesu` | Laptop   | x86_64-linux  | ThinkPad X1 Nano, LUKS + TPM2 + lanzaboote  |
| `nanoda`   | Laptop   | x86_64-linux  | Let's Note CF-SZ6                           |
| `kamo`     | Handheld | x86_64-linux  | ROG Ally                                    |
| `dayo`     | Server   | aarch64-linux | Raspberry Pi 4                              |
