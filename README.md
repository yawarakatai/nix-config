# My NixOS Setup

Personal notes for managing my NixOS machines. No fluff, just what I actually need to remember.

## My Machines

**desuwa** - Main desktop
- Ryzen 7 3700X, RTX 3080, 16GB RAM
- 4K 144Hz monitor, niri compositor
- The beast for gaming and heavy work

**nanodesu** - Laptop
- Portable machine

**dayo** - Other machine
- TODO: document this when I remember what it is

## Daily Commands (muscle memory)

```bash
nd      # Preview changes (dry build) - USE THIS FIRST
nt      # Test temporarily (no bootloader)
ns      # Switch now + update bootloader
nb      # Apply on next boot only
nus     # Update everything then switch
nfc     # Check if config is valid
ngc     # Clean up old generations
```

The `n` prefix = nixos stuff. These are defined in `modules/system/rebuild-helper.nix`.

## When Shit Breaks

```bash
# Syntax error? Check first
nix flake check

# Need more details?
sudo nixos-rebuild switch --flake .#desuwa --show-trace

# Fucked something up? Rollback
sudo nixos-rebuild switch --rollback

# Or just reboot and pick old generation from boot menu
```

**niri-flake build failing?** Run `ulimit -n 4096` first.
See: https://github.com/sodiboo/niri-flake/issues/1300

## How Do I...

### Add a program

**Just for me (home-manager):**
Edit `home/desuwa/home.nix`, add to `home.packages`:
```nix
home.packages = with pkgs; [
  your-new-package
];
```

**System-wide:**
Edit `hosts/desuwa/configuration.nix` or add to `modules/system/base.nix`:
```nix
environment.systemPackages = with pkgs; [
  your-new-package
];
```

### Change colors/theme

Everything is in one place: `modules/home/themes/night-neon.nix`

Edit colors there, rebuild, done. All programs (terminal, waybar, helix, etc.) will update.

### Change monitor settings

Edit `hosts/desuwa/vars.nix` - change monitor name, resolution, refresh rate, etc.

DON'T edit the niri config directly.

### Add a new module

Copy `docs/MODULE_TEMPLATE.nix`, follow the pattern. Read `docs/CODING_GUIDE.md` if you care about consistency.

### Update everything

```bash
nus
```

Or manually:
```bash
nix flake update && sudo nixos-rebuild switch --flake .#desuwa
```

## Config Structure (where is what)

```
hosts/desuwa/
  vars.nix              ← Machine-specific stuff (monitor, timezone, etc.)
  configuration.nix     ← System config for this machine
  hardware-configuration.nix

home/desuwa/
  home.nix              ← My personal packages and config

modules/system/
  base.nix              ← Common system stuff for all machines
  nvidia.nix            ← RTX 3080 drivers
  yubikey.nix           ← YubiKey for GPG/SSH
  logiops.nix           ← MX Master 3S mouse config
  rebuild-helper.nix    ← Where nd, ns, etc. are defined
  ...

modules/home/
  themes/night-neon.nix ← ALL the colors
  wayland/              ← niri, waybar, mako, vicinae
  shell/                ← nushell, starship, atuin, zoxide
  editors/              ← helix, vscode
  terminal/             ← alacritty
  tools/                ← yazi, lazygit, cli stuff
  ...

lib/
  terminal-colors.nix   ← Shared color scheme functions
  module-options.nix    ← Helper functions for modules

docs/
  CODING_GUIDE.md       ← How I organize code
  REFACTORING.md        ← What I changed recently
  MODULE_TEMPLATE.nix   ← Template for new modules
```

## Current Setup (desuwa)

- **OS**: NixOS unstable
- **Compositor**: niri (Wayland, i3-like but scrollable)
- **Terminal**: Alacritty
- **Shell**: nushell (with starship prompt, zoxide, atuin history)
- **Editor**: Helix (main), VSCode (when I need it)
- **Bar**: waybar
- **Launcher**: Vicinae
- **File manager**: yazi (terminal), Nautilus (GUI)
- **Browser**: Firefox
- **Japanese input**: fcitx5 + mozc
- **Theme**: Pure black background + neon colors (cyan, magenta, purple)

## Storage (Btrfs subvolumes)

```
@       → /               Root (can snapshot/restore)
@home   → /home           User files
@nix    → /nix            Nix store (separate for efficiency)
@log    → /var/log        Logs
@cache  → /var/cache      Cache (can nuke anytime)
@tmp    → /tmp            Temporary files
```

## Things to Remember

- **ALWAYS** run `nd` before `ns` - preview changes first
- **DON'T** edit individual program color configs, use `night-neon.nix`
- **DON'T** commit without running `nfc` first
- **Monitor settings** go in `vars.nix`, not in niri config
- **New modules** should follow the template in `docs/`
- The rebuild commands (nd, ns, etc.) make life easier, use them

## Hardware-Specific Stuff

desuwa has:
- NVIDIA proprietary drivers (for RTX 3080)
- YubiKey support (GPG + SSH)
- Logitech MX Master 3S custom button mappings
- Lofree Flow keyboard config

Check `modules/system/` for the specific configs.

## Git Workflow

Working on branch: `claude/rewrite-readme-01LHJEsjHeR9gx7Vstb2Ys1L`

Normal workflow:
1. Make changes
2. `nfc` to check syntax
3. `nd` to preview
4. `nt` or `ns` to apply
5. Test stuff
6. Commit if it works

## Useful Links

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Niri Wiki](https://github.com/YaLTeR/niri/wiki)
- [niri-flake repo](https://github.com/sodiboo/niri-flake)

---

**Last major refactor**: Check `docs/REFACTORING.md` for details on what changed.
