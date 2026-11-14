# Installing a host

## Prepare the target

Boot the official NixOS ISO on the target machine, then:

```bash
nmtui      # connect to Wi-Fi if needed
passwd     # set a password for the nixos user
ip addr    # find the IP address
```

Review `hosts/<host>/storage/disko.nix` and make sure its disk paths match the
target machine. Installing formats every disk in the layout.

## Run the installer

From the root of this repository:

```bash
nix run .#install-host -- kamo nixos@192.168.0.99
```

Use `--no-install` to only generate files and rekey, and `--help` for the other
options. The installer:

- installs a temporary SSH key so the ISO password is asked only once
- corrects a large clock skew on the ISO
- shows the remote disk IDs for comparison with `storage/disko.nix`
- writes `hosts/<host>/generated/hardware-configuration.nix` and
  `hosts/<host>/generated/ssh_host_ed25519_key.pub`, and stages them in Git
- runs `agenix rekey` and stages `secrets/rekeyed/<host>/`
- evaluates the host and, after you type the host name, runs `nixos-anywhere`,
  building on the target when its architecture differs

Connect as the ISO's `nixos` user, not root. The script uses `sudo` on the
target only to read the ISO's private host key.

## SSH host keys

The ISO's SSH host key becomes the installed system's host key: the installer
copies it to `/tmp/<host>/etc/ssh` for `nixos-anywhere --extra-files`. This
keeps three things in agreement:

1. `hosts/<host>/generated/ssh_host_ed25519_key.pub`
2. the agenix recipients of `secrets/rekeyed/<host>/`
3. the installed `/etc/ssh/ssh_host_ed25519_key`

Private host keys are never committed. `secrets/keys.nix` reads each host's
public key from `generated/`, so reinstalling needs no edit there; a new host
only needs its entry under `hosts`.

## Disk layouts

Each host owns its whole layout in `storage/disko.nix`, without shared disko
helpers, so a destructive layout is readable in one place. Simple single-boot
machines use ext4 unless they need Btrfs features such as snapshots,
send/receive, or compression.
