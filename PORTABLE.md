# Portable development environment

The `portable` Home Manager configuration installs the command-line tools, Zsh, Starship, Helix, Git, Lazygit, direnv, Firn, Codex, and Claude Code from this repository on a non-NixOS Linux system.

Two outputs are available:

- `portable` for `x86_64-linux`
- `portable-aarch64` for `aarch64-linux`

The configuration assumes the user is named `yawarakatai` and has the home directory `/home/yawarakatai`.

## Install Nix

Nix must be installed before this flake can be evaluated. On a normal Linux distribution or WSL with systemd enabled, use the multi-user installation:

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

Restart the shell after installation and verify it:

```bash
nix --version
```

Make sure flakes are enabled. For a per-user configuration:

```bash
mkdir -p ~/.config/nix
printf '%s\n' 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
```

## Apply directly from GitHub

On x86-64 Linux or WSL:

```bash
nix run github:nix-community/home-manager -- \
  switch --flake github:yawarakatai/nix-config#portable
```

On AArch64 Linux:

```bash
nix run github:nix-community/home-manager -- \
  switch --flake github:yawarakatai/nix-config#portable-aarch64
```

Open a new shell after the first switch. Home Manager is then installed into the profile, so later updates can use:

```bash
home-manager switch --flake github:yawarakatai/nix-config#portable
```

## Apply from a local checkout

```bash
git clone https://github.com/yawarakatai/nix-config.git ~/.config/nix-config
cd ~/.config/nix-config
nix run github:nix-community/home-manager -- switch --flake .#portable
```

Subsequent updates:

```bash
cd ~/.config/nix-config
git pull
home-manager switch --flake .#portable
```

## WSL notes

Use WSL2. Enabling systemd is recommended because it gives Nix's multi-user daemon and user services a conventional Linux environment. Add the following to `/etc/wsl.conf` when necessary:

```ini
[boot]
systemd=true
```

Then shut WSL down from Windows and reopen it:

```powershell
wsl --shutdown
```

This profile does not install the NixOS desktop, Niri, hardware configuration, or system services.
