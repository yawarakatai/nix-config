# NixOS Setup Guide

Complete guide for installing NixOS with this configuration.

## Prerequisites

- NixOS installation USB
- UEFI boot support
- 2TB NVMe SSD
- Internet connection

## Part 1: Base NixOS Installation

### 1.1 Partition the Disk

```bash
lsblk  # Identify disk (should be /dev/nvme0n1)

# Partition
sudo parted /dev/nvme0n1 -- mklabel gpt
sudo parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 1GiB
sudo parted /dev/nvme0n1 -- set 1 esp on
sudo parted /dev/nvme0n1 -- mkpart primary btrfs 1GiB 100%

# Format
sudo mkfs.fat -F 32 -n BOOT /dev/nvme0n1p1
sudo mkfs.btrfs -L nixos /dev/nvme0n1p2
```

### 1.2 Create Btrfs Subvolumes

```bash
sudo mount /dev/nvme0n1p2 /mnt

sudo btrfs subvolume create /mnt/@
sudo btrfs subvolume create /mnt/@home
sudo btrfs subvolume create /mnt/@nix
sudo btrfs subvolume create /mnt/@log
sudo btrfs subvolume create /mnt/@cache
sudo btrfs subvolume create /mnt/@tmp

sudo umount /mnt
```

### 1.3 Mount Filesystems

```bash
sudo mount -o compress=zstd,noatime,subvol=@ /dev/nvme0n1p2 /mnt
sudo mkdir -p /mnt/{boot,home,nix,var/log,var/cache,tmp}

sudo mount -o compress=zstd,noatime,subvol=@home /dev/nvme0n1p2 /mnt/home
sudo mount -o compress=zstd,noatime,subvol=@nix /dev/nvme0n1p2 /mnt/nix
sudo mount -o compress=zstd,noatime,subvol=@log /dev/nvme0n1p2 /mnt/var/log
sudo mount -o compress=zstd,noatime,subvol=@cache /dev/nvme0n1p2 /mnt/var/cache
sudo mount -o compress=zstd,noatime,subvol=@tmp /dev/nvme0n1p2 /mnt/tmp
sudo mount /dev/nvme0n1p1 /mnt/boot
```

### 1.4 Generate Initial Configuration

```bash
sudo nixos-generate-config --root /mnt
sudo nano /mnt/etc/nixos/configuration.nix
```

Add flakes support and user:

```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];

users.users.yawarakatai = {
  isNormalUser = true;
  extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
  hashedPassword = "$6$...";  # Generate with: nix-shell -p mkpasswd && mkpasswd -m sha-512
};
```

### 1.5 Install NixOS

```bash
sudo nixos-install
# Set root password when prompted, then reboot
```

## Part 2: Deploy Custom Configuration

### 2.1 Clone Configuration

```bash
cd ~
git clone https://github.com/yourusername/nix-config ~/.config/nix-config
cd ~/.config/nix-config
```

### 2.2 Generate Hardware Config

```bash
sudo nixos-generate-config --show-hardware-config > hosts/desuwa/hardware-configuration.nix
```

### 2.3 Build and Switch

```bash
nix flake lock
nix flake check
sudo nixos-rebuild dry-build --flake ~/.config/nix-config#desuwa
sudo nixos-rebuild switch --flake ~/.config/nix-config#desuwa
reboot
```

## Part 3: Post-Installation

### Verify Installation

```bash
echo $WAYLAND_DISPLAY  # Check niri
nos --help             # Test rebuild helpers
```

### Optional: Setup YubiKey

```bash
ykman list
gpg --full-generate-key
gpg --edit-key YOUR_KEY_ID  # Use 'keytocard' command
```

### Optional: Setup sops-nix

```bash
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
age-keygen -y ~/.config/sops/age/keys.txt  # Copy public key for .sops.yaml
```

### Optional: Symlink to /etc/nixos

```bash
sudo rm -rf /etc/nixos
sudo ln -s ~/.config/nix-config /etc/nixos
```

## Part 4: Customization

- **Theme**: Edit `modules/home/themes/night-neon.nix`
- **Packages**: Edit `home/desuwa/home.nix`
- **Keybindings**: Edit `modules/home/wayland/niri/binds.nix`

Then rebuild: `nos`

## Troubleshooting

```bash
nix flake check                                            # Syntax error
nixos-rebuild switch --flake .#desuwa --show-trace         # Detailed error
sudo nixos-rebuild switch --rollback                       # Rollback
nvidia-smi                                                 # NVIDIA issues
journalctl -u niri --no-pager | tail -50                   # niri logs
```

## Maintenance

```bash
nus                                      # Update everything
nog                                      # Garbage collection
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

## Resources

- [NixOS Wiki](https://nixos.wiki/)
- [Home Manager Options](https://nix-community.github.io/home-manager/options.html)
- [Nix Package Search](https://search.nixos.org/)
