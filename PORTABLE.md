# Portable development environment

The standalone Home Manager configuration installs CLI tools, Zsh, Starship,
Helix, Git, Lazygit, direnv, Python, Plainix, Codex, and pi on non-NixOS Linux.
It does not install the NixOS desktop, Niri, hardware configuration, or system
services, and it does not change your login shell.

Two outputs are available. Check your architecture with `uname -m`:

- `portable` for `x86_64-linux` (`x86_64`)
- `portable-aarch64` for `aarch64-linux` (`aarch64`)

On ARM64, replace `portable` with `portable-aarch64` in the commands below.

## Before installing

On a school or other managed device, obtain permission to install Nix and use
these tools. If installation requires administrator access, ask the administrator;
do not bypass device restrictions. Apply Home Manager only to your own account,
never with `sudo`.

This is still a personal configuration: it includes yawarakatai's Git identity
and SSH host settings. Review them before applying, along with any existing
shell, Git, and SSH configuration. Private SSH keys and API credentials are not
installed by this profile.

## Install Nix

Skip this section if `nix --version` already works.

On a normal Linux distribution or WSL with systemd enabled, use the multi-user
installer with administrator approval:

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

For SELinux distributions such as Fedora or Bazzite, use a compatible installer,
for example Determinate Nix, with administrator approval:

```bash
curl --proto '=https' --tlsv1.2 -sSf -L \
  https://install.determinate.systems/nix | \
  sh -s -- install
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

## Select your account

Before every build or update, set the account explicitly in the current shell:

```bash
export PORTABLE_USERNAME="$(id -un)"
export PORTABLE_HOME="$HOME"
```

These overrides are read only with `--impure`. They do not change NixOS host
accounts. Without overrides, the username defaults to `yawarakatai` and the home
directory to `/home/<username>`. Pure evaluation ignores the environment and uses
`yawarakatai` and `/home/yawarakatai`, so repository checks remain reproducible.

## Install from a local checkout

```bash
git clone https://github.com/yawarakatai/nix-config.git ~/.config/nix-config
cd ~/.config/nix-config
```

Confirm that the configuration targets your own account:

```bash
nix eval --impure --json .#homeConfigurations.portable.config.home \
  --apply 'home: { inherit (home) username homeDirectory; }'
```

Build first. This downloads/builds packages and creates `result-portable`, but
does not apply the configuration to your home directory:

```bash
nix build --impure --out-link result-portable \
  .#homeConfigurations.portable.activationPackage
```

When ready, apply the built generation as your normal user:

```bash
HOME_MANAGER_BACKUP_EXT=portable-backup ./result-portable/activate
```

Existing conflicting files are backed up with a `.portable-backup` suffix. If
that backup already exists, resolve the conflict manually rather than overwriting
it. Keep backups until you are satisfied with the new configuration.

Home Manager is now installed in your profile. Reopen your terminal to refresh
the environment, then run `zsh` if you want to use the configured shell. The
system's default login shell is not changed automatically.

### Updates

Set the account variables again in each new shell before updating:

```bash
cd ~/.config/nix-config
git pull
export PORTABLE_USERNAME="$(id -un)"
export PORTABLE_HOME="$HOME"
home-manager switch --impure -b portable-backup --flake .#portable
```

The initial build uses the Home Manager version pinned by this flake, without
bootstrapping a separate, potentially incompatible Home Manager CLI.

## Install directly from GitHub

After setting the account variables above, you can also build without a checkout:

```bash
nix build --impure --out-link result-portable \
  github:yawarakatai/nix-config#homeConfigurations.portable.activationPackage
HOME_MANAGER_BACKUP_EXT=portable-backup ./result-portable/activate
```

For subsequent updates, set the account variables again and use:

```bash
home-manager switch --impure -b portable-backup \
  --flake github:yawarakatai/nix-config#portable
```

## Repository validation

`nix develop -c just eval-home portable` evaluates one activation derivation.
`nix develop -c just eval-homes` evaluates every standalone Home Manager output,
including ARM64, without building their packages. `just check` includes this
validation. These commands use pure evaluation and the reproducible default
account, not the account overrides.

## WSL notes

Use WSL2. Enabling systemd is recommended because it gives Nix's multi-user daemon
and user services a conventional Linux environment. Add the following to
`/etc/wsl.conf` when necessary and permitted:

```ini
[boot]
systemd=true
```

Then shut WSL down from Windows and reopen it:

```powershell
wsl --shutdown
```
