# Architecture

The configuration is being refactored toward a dendritic, aspect-oriented
layout: each feature is a module, importing it enables it, and profiles only
aggregate features.

## Layout

```text
flake.nix
hosts/<host>/
  default.nix              # import glue only
  hardware.nix             # hardware modules and device quirks
  system.nix               # handwritten host settings
  storage/disko.nix        # install disk layout (stable /dev/disk/by-id paths)
  storage/default.nix      # optional runtime storage settings
  generated/               # written by install-host: hardware configuration, SSH host public key
  home/default.nix         # Home Manager host-only additions
  README.md                # optional operational notes
modules/
  flake/                   # flake-parts entry modules: outputs, tests, checks, dev shell, install-host, diff-config
  profiles/                # aggregators only (system/, home/)
  core/                    # boot, Nix, users, locale, and networking for every host
  desktop/                 # Wayland desktop: Niri, Noctalia, greetd
  gaming/                  # Steam and Jovian
  hardware/ input/ laptop/ # device support
  github/                  # gh with a read-only token delivered by agenix (system.nix + home.nix)
  security/                # agenix and YubiKey support
  services/                # system services, including dayo's router and backup server
  ssh/                     # sshd, client and known hosts, desktop YubiKey identities (system.nix + home.nix)
  storage/                 # Btrfs and zram
  theme/                   # palette and Stylix (see its README)
  home/                    # Home Manager features
secrets/                   # encrypted sources, master identities, keys.nix, rekeyed/<host>/
```

`modules/flake/module-registry.nix` only publishes stable NixOS and Home
Manager module names; it owns no feature implementation.

## Profiles

Each host picks one system profile in `modules/flake/nixos.nix` and adds its own
imports in `hosts/<host>/default.nix`. System profiles build on each other:
`minimal` (`dayo`), `base`, `secret`, `desktop`, `desktop-niri` (`desuwa`,
`kamo`), and `laptop` (`nanodesu`).

Home Manager profiles: `default.nix` holds shared basics, `desktop.nix` adds
desktop, development, and SSH features, `recording.nix` is `desuwa`'s
screen-recording account, and `portable.nix` is the standalone configuration
for non-NixOS Linux (see [portable.md](portable.md)).

## Ownership

- Noctalia owns wallpaper, including its JSON state. Stylix owns colors, fonts,
  cursor, and application theming only; do not set `stylix.image`.
- Niri owns compositor behavior, keybindings, window rules, and output
  defaults. wlr-randr wrappers are for emergency display changes.
- Where Home Manager manages Zsh and Starship, it owns their initialization;
  `modules/core/users.nix` disables the duplicate NixOS initialization while
  keeping completion paths. Hosts without those features keep the NixOS
  defaults.
- Desktop SSH authentication uses Home Manager's `ssh-agent`. The GCR SSH agent
  is disabled to avoid a second agent; GNOME Keyring remains for application
  secrets.
- Nix store deduplication runs on the weekly `nix-optimise` timer, not on every
  store import, so identical files can briefly use extra space.
- On `dayo`, systemd-networkd and nftables own networking; NetworkManager comes
  only from the desktop profile.
- On `kamo`, Jovian owns Gaming Mode, SDDM, input integration, and charging
  limits; Niri is the development desktop (see
  [hosts/kamo/README.md](../hosts/kamo/README.md)).

## Where to edit

| Change                                                   | Edit                                                     |
| -------------------------------------------------------- | -------------------------------------------------------- |
| Host boot, services, display, wallpaper, or packages     | `hosts/<host>/system.nix`                                |
| Host hardware modules and device quirks                  | `hosts/<host>/hardware.nix`                              |
| Host install disk layout                                 | `hosts/<host>/storage/disko.nix`                         |
| Generated hardware facts or SSH host public key          | `hosts/<host>/generated/` via [install-host](install.md) |
| Home Manager host-only additions                         | `hosts/<host>/home/default.nix`                          |
| Reusable NixOS or Home Manager features                  | `modules/`                                               |
| Profile aggregation                                      | `modules/profiles/`                                      |
| Published flake module names                             | `modules/flake/module-registry.nix`                      |
| NixOS login shell and global shell initialization        | `modules/core/users.nix`                                 |
| User-facing shell settings                               | `modules/home/shell/`                                    |
| Default kernel (`dayo` overrides it in `hardware.nix`)   | `modules/core/boot.nix`                                  |
| Portable account parameters and optional features        | `modules/flake/home.nix`                                 |
| `kamo` gaming and session integration                    | `modules/gaming/jovian.nix`                              |
| `desuwa`'s screen-recording account                      | `modules/desktop/recording-user.nix`                     |
| `dayo`'s router and backup server                        | `modules/services/router.nix`, `backup-server.nix`       |
| `dayo`'s line facts and backup quotas                    | `hosts/dayo/system.nix`                                  |
| Backup clients (not imported yet)                        | `modules/services/backup-client.nix`                     |
| Evaluated host invariants (nix-unit)                     | `modules/flake/tests.nix`                                |
| Checks that build or boot something, such as VM tests    | `modules/flake/checks.nix`                               |

Display outputs are set with `my.display.outputs`, keyed by output name; set
`enable = false` to keep a known external display disabled. The wallpaper,
`my.wallpaper.image`, is shared across displays; when it is `null`, Niri uses
`my.wallpaper.fallbackColor` as a solid background.
