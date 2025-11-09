# NixOS Setup Guide

Complete step-by-step guide for installing and configuring NixOS with this configuration.

## Prerequisites

- NixOS installation media (USB drive)
- Target machine with:
  - UEFI boot support
  - 2TB NVMe SSD
  - Internet connection

## 📀 Part 1: Base NixOS Installation

### 1.1 Boot Installation Media

Boot from the NixOS installation USB.

### 1.2 Partition the Disk

We'll use Btrfs with subvolumes.

```bash
# Identify your disk (should be /dev/nvme0n1)
lsblk

# Partition the disk
sudo parted /dev/nvme0n1 -- mklabel gpt
sudo parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 1GiB
sudo parted /dev/nvme0n1 -- set 1 esp on
sudo parted /dev/nvme0n1 -- mkpart primary btrfs 1GiB 100%

# Format partitions
sudo mkfs.fat -F 32 -n BOOT /dev/nvme0n1p1
sudo mkfs.btrfs -L nixos /dev/nvme0n1p2
```

### 1.3 Create Btrfs Subvolumes

```bash
# Mount the root partition
sudo mount /dev/nvme0n1p2 /mnt

# Create subvolumes
sudo btrfs subvolume create /mnt/@
sudo btrfs subvolume create /mnt/@home
sudo btrfs subvolume create /mnt/@nix
sudo btrfs subvolume create /mnt/@log
sudo btrfs subvolume create /mnt/@cache
sudo btrfs subvolume create /mnt/@tmp

# Unmount
sudo umount /mnt
```

### 1.4 Mount Filesystems

```bash
# Mount root subvolume
sudo mount -o compress=zstd,noatime,subvol=@ /dev/nvme0n1p2 /mnt

# Create mount points
sudo mkdir -p /mnt/{boot,home,nix,var/log,var/cache,tmp}

# Mount other subvolumes
sudo mount -o compress=zstd,noatime,subvol=@home /dev/nvme0n1p2 /mnt/home
sudo mount -o compress=zstd,noatime,subvol=@nix /dev/nvme0n1p2 /mnt/nix
sudo mount -o compress=zstd,noatime,subvol=@log /dev/nvme0n1p2 /mnt/var/log
sudo mount -o compress=zstd,noatime,subvol=@cache /dev/nvme0n1p2 /mnt/var/cache
sudo mount -o compress=zstd,noatime,subvol=@tmp /dev/nvme0n1p2 /mnt/tmp

# Mount boot partition
sudo mount /dev/nvme0n1p1 /mnt/boot
```

### 1.5 Generate Initial Configuration

```bash
# Generate hardware config
sudo nixos-generate-config --root /mnt

# Enable flakes temporarily
sudo nano /mnt/etc/nixos/configuration.nix
```

Add this line:

```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

### 1.6 Configure User Account

**IMPORTANT:** You must configure your user account BEFORE running nixos-install. NixOS will automatically create the user during installation.

First, generate a password hash:

```bash
# Install mkpasswd in the live environment
nix-shell -p mkpasswd

# Generate password hash
mkpasswd -m sha-512
# Enter your password when prompted
# Copy the output (starts with $6$...)
```

Now edit the configuration to add your user:

```bash
sudo nano /mnt/etc/nixos/configuration.nix
```

Add your user configuration (replace the hash with your generated hash):

```nix
users.users.yawarakatai = {
  isNormalUser = true;
  description = "Yawarakatai";
  extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
  hashedPassword = "$6$rounds=656000$...";  # Paste your hash here
};
```

### 1.7 Install NixOS

```bash
sudo nixos-install
# Set root password when prompted
# Reboot when done
```

## 🔧 Part 2: Deploy Custom Configuration

### 2.1 Boot into Installed System

1. Remove installation media
2. Boot into the new system
3. Login as your user (yawarakatai) using the password you set

### 2.2 Enable Flakes System-wide

```bash
# Edit configuration
nano /etc/nixos/configuration.nix
```

Ensure this is present:

```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

```bash
# Apply changes
nixos-rebuild switch
```

### 2.3 Clone/Copy Configuration

```bash
# As your regular user
cd ~
mkdir -p .config

# Download from GitHub
git clone https://github.com/yourusername/nix-config ~/.config
```

### 2.4 Generate Hardware Configuration

```bash
cd ~/.config/nix-config
sudo nixos-generate-config --show-hardware-config > hosts/desuwa/hardware-configuration.nix
```

Review and adjust if needed:

```bash
nano hosts/desuwa/hardware-configuration.nix
```

### 2.5 Initialize Flake

```bash
cd ~/.config/nix-config

# Generate flake.lock
nix flake lock

# Check for errors
nix flake check
```

### 2.6 Build and Switch

```bash
# Dry run (check for errors)
sudo nixos-rebuild dry-build --flake ~/.config/nix-config#desuwa

# If successful, build and switch
sudo nixos-rebuild switch --flake ~/.config/nix-config#desuwa
```

This will take some time on first build as it downloads and compiles everything.

### 2.7 Reboot

```bash
reboot
```

## 🎉 Part 3: Post-Installation

### 3.1 Verify Installation

After reboot, log in as yawarakatai.

Check that everything is working:

```bash
# Check niri is running
echo $WAYLAND_DISPLAY

# Test rebuild helpers
nos --help  # Should show nixos-rebuild help

# Check terminal
ghostty --version

# Check shell
nu --version
```

### 3.2 Configure Git

Your git is already configured, but verify:

```bash
git config --global --list
```

### 3.3 Setup YubiKey (Optional)

If you have a YubiKey:

```bash
# Check YubiKey is detected
ykman list

# Generate GPG key (if not already on YubiKey)
gpg --full-generate-key

# Move to YubiKey
gpg --edit-key YOUR_KEY_ID
# Use 'keytocard' command
```

### 3.4 Setup sops-nix (Optional, for future)

```bash
# Generate age key
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt

# View public key
age-keygen -y ~/.config/sops/age/keys.txt
# Copy this for .sops.yaml
```

Create `.sops.yaml`:

```bash
cd ~/.config/nix-config
nano .sops.yaml
```

Add:

```yaml
keys:
  - &user_yawarakatai age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

creation_rules:
  - path_regex: secrets/[^/]+\.yaml$
    key_groups:
      - age:
          - *user_yawarakatai
```

### 3.5 Make Configuration a Git Repository

```bash
cd ~/.config/nix-config

# Initialize git
git init
git add .
git commit -m "Initial NixOS configuration"

# Optionally, push to GitHub
# git remote add origin git@github.com:yawarakatai/nix-config.git
# git push -u origin main
```

### 3.6 Symlink to /etc/nixos (Optional)

For compatibility with traditional commands:

```bash
sudo rm -rf /etc/nixos
sudo ln -s ~/.config/nix-config /etc/nixos
```

Now you can use:

```bash
sudo nixos-rebuild switch --flake /etc/nixos#desuwa
```

## 🎨 Part 4: Customization

### 4.1 Change Theme Colors

Edit `modules/home/theme.nix`:

```bash
hx ~/.config/nix-config/modules/home/theme.nix
```

Change colors and rebuild:

```bash
nos
```

### 4.2 Add More Software

Edit `home/yawarakatai/home.nix`:

```bash
hx ~/.config/nix-config/home/yawarakatai/home.nix
```

Add packages to `home.packages = with pkgs; [ ... ];`

Rebuild:

```bash
nos
```

### 4.3 Adjust Keybindings

Edit niri config:

```bash
hx ~/.config/nix-config/modules/home/wayland/niri.nix
```

Rebuild:

```bash
nos
```

## 🐛 Troubleshooting

### Build Errors

```bash
# Check syntax
nix flake check

# Show detailed error
nixos-rebuild switch --flake ~/.config/nix-config#desuwa --show-trace
```

### NVIDIA Issues

If you have display problems:

```bash
# Check NVIDIA driver is loaded
nvidia-smi

# Check kernel modules
lsmod | grep nvidia
```

### niri Won't Start

Check logs:

```bash
journalctl -u niri --no-pager | tail -50
```

Try starting manually:

```bash
niri
```

### Missing Packages

Some packages might not be available on nixpkgs-unstable. Check:

```bash
nix search nixpkgs package-name
```

## 📋 Maintenance

### Regular Updates

```bash
# Update flake inputs and rebuild
nou

# Or manually:
cd ~/.config/nix-config
nix flake update
nos
```

### Garbage Collection

```bash
# Using helper
nog

# Or manually
sudo nix-collect-garbage --delete-older-than 30d
nix-store --optimise
```

### List Generations

```bash
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

### Rollback

From GRUB menu, select older generation.

Or:

```bash
sudo nixos-rebuild switch --rollback
```

## 🎯 Next Steps

1. Explore niri keybindings (Mod+? or check niri.nix)
2. Customize waybar modules
3. Add development environments with `nix develop`
4. Set up backups for ~/.config/nix-config
5. Consider using agenix or sops-nix for secrets

## 📚 Learning Resources

- [Nix Pills](https://nixos.org/guides/nix-pills/) - Deep dive into Nix
- [NixOS Wiki](https://nixos.wiki/) - Community documentation
- [Home Manager Options](https://nix-community.github.io/home-manager/options.html)
- [Nix Package Search](https://search.nixos.org/)

## 🆘 Getting Help

- [NixOS Discourse](https://discourse.nixos.org/)
- [r/NixOS](https://reddit.com/r/NixOS)
- [NixOS Discord](https://discord.gg/RbvHtGa)

---

**Congratulations! Your NixOS system is now fully configured.** 🎉
