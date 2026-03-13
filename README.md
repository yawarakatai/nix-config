# New Machine Setup

This guide covers adding a new host to the flake and performing a fresh NixOS install.

---

## 1. Add the New Host

### 1.1 Create host directory

```
hosts/
└── <hostname>/
    ├── default.nix
    ├── disko.nix
    ├── hardware-configuration.nix
    └── home/
        └── default.nix
```

### 1.2 `disko.nix`

Copy from an existing host (e.g. `hosts/desuno/disko.nix`) and update the disk device path.

```bash
# Find the disk ID on the target machine
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
    ./disko.nix
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

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
# Or simply rsync the repo
rsync -av --exclude='.git' ./ root@<target-ip>:/mnt/etc/nixos/
```

### 3.5 Partition and format with disko

```bash
nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \
  --mode disko /path/to/hosts/<hostname>/disko.nix
```

Or from the flake directly:

```bash
nix run github:nix-community/disko#disko-install -- \
  --flake .#<hostname> \
  --disk main /dev/sdX
```

### 3.6 Mount filesystems (if not using disko-install)

```bash
mount /dev/<root-partition> /mnt
mount /dev/<esp-partition> /mnt/boot
```

### 3.7 Install

```bash
nixos-install --flake .#<hostname> --no-root-passwd --option cores 2 # if memory error occures
```

### 3.8 Copy host keys

```bash
cp /etc/ssh/ssh_host_*_key     /mnt/etc/ssh/
cp /etc/ssh/ssh_host_*_key.pub /mnt/etc/ssh/
chmod 600 /mnt/etc/ssh/ssh_host_*_key
chmod 644 /mnt/etc/ssh/ssh_host_*_key.pub
```

### 3.9 Reboot

```bash
reboot
```

---

## 4. Post-install

### 4.1 Set user password

On the first boot (password is managed via agenix, but if needed):

```bash
passwd <username>
```

### 4.2 Authorize YubiKey for SSH

Ensure `~/.ssh/yubikey_5.pub` and `~/.ssh/yubikey_5c.pub` are present (home-manager deploys these automatically).

### 4.3 Sync secrets

If rekeying was done on another machine, push the updated repo and rebuild:

```bash
nh os switch .#<hostname>
```

---

## 5. Ongoing Rebuilds

```bash
# Rebuild and switch (uses nh for better output)
nh os switch

# Update flake inputs
nix flake update

# Garbage collection (handled automatically by nh clean, configured in nix.nix)
nh clean all
```

---

## Reference: Host Overview

| Host       | Type    | Arch           | Notes                        |
|------------|---------|----------------|------------------------------|
| `desuwa`   | Desktop | x86_64-linux   | Geforce RTX 3080             |
| `desuno`   | Desktop | x86_64-linux   | Radeon RX 590                |
| `nanodesu` | Laptop  | x86_64-linux   | Thinkpad x1 Carbon           |
| `kamo`     | Handheld| x86_64-linux   | ROG Ally                     |
| `dayo`     | Server  | aarch64-linux  | Raspberry Pi 4               |
