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

Minimal example for a desktop host:

```nix
{ pkgs, ... }:
{
  imports = [
    (import ../../modules/system/storage/disko-btrfs.nix {
      device = "/dev/disk/by-id/DISK_ID";
    })
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "50%";
  };

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

## 2. Secrets (agenix-rekey)

> Skip to [Section 3](#3-install-nixos) if reinstalling and secrets are already rekeyed.

### 2.1 Get the host SSH public key

Boot the NixOS ISO on the target machine and retrieve the host key:

```bash
ssh-keygen -A
cat /etc/ssh/ssh_host_ed25519_key.pub
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

### 3.3 Enable SSH (optional, for remote install)

```bash
passwd nixos
systemctl start sshd
ip a  # note the IP
```

### 3.4 Copy the flake to the target

```bash
# From your workstation
nix copy --to ssh://root@<target-ip> .#nixosConfigurations.<hostname>.config.system.build.toplevel
# Or simply clone the repo
git clone https://github.com/yawarakatai/nix-config
cd nix-config
```

### 3.5 Partition, format, and install

#### Option A: nixos-anywhere (recommended if another NixOS machine is available)

Boot from ISO, then set a password and connect to network:
```bash
passwd nixos
nmtui
```

From another machine:
```bash
nix run github:nix-community/nixos-anywhere -- \
  --flake .#<hostname> \
  root@<target-ip>
```

#### Option B: Local install from ISO

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

### 3.6 Reboot

```bash
reboot
```

## 4. Ongoing Rebuilds

```bash
# Rebuild and switch
nh os switch

# Update flake inputs
nix flake update

# Garbage collection (runs automatically via nh clean)
nh clean all
```

## Reference: Host Overview

| Host       | Type     | Arch          | Notes                     |
|------------|----------|---------------|---------------------------|
| `desuwa`   | Desktop  | x86_64-linux  | NVIDIA RTX 3080           |
| `desuno`   | Desktop  | x86_64-linux  | Radeon RX 590             |
| `nanodesu` | Laptop   | x86_64-linux  | ThinkPad X1 Nano          |
| `kamo`     | Handheld | x86_64-linux  | ROG Ally                  |
| `dayo`     | Server   | aarch64-linux | Raspberry Pi 4            |
