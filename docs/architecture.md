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
  flake/                   # flake-parts entry modules: hosts, portable shell, checks, nix-unit tests, dev shell, packages (install-host, diff-config)
  profiles/                # aggregators only (system/, home/)
  core/                    # boot, Nix, users, locale, and networking for every host
  desktop/                 # Wayland desktop: Niri, Noctalia, greetd
  gaming/                  # Steam, Jovian, and the headless Remote Play host
  hardware/ input/ laptop/ # device support
  github/                  # gh with a read-only token delivered by agenix (system.nix + home.nix)
  security/                # agenix and YubiKey support
  services/                # system services, including dayo's router and backup server
  ssh/                     # sshd, client and known hosts, desktop YubiKey identities (system.nix + home.nix)
  syncthing/               # Syncthing peers (home.nix) and firewall (system.nix)
  storage/                 # Btrfs, zram, and the state a tmpfs root preserves
  theme/                   # palette and Stylix (see its README)
  home/                    # Home Manager features
secrets/                   # encrypted sources, master identities, keys.nix, rekeyed/<host>/
```

## Profiles

Each host picks one system profile in `modules/flake/nixos.nix` and adds its own
imports in `hosts/<host>/default.nix`. System profiles build on each other:
`minimal` (`dayo`), `base`, `secret`, `desktop`, `desktop-niri` (`desuwa`,
`kamo`), and `laptop` (`nanodesu`).

Home Manager profiles: `default.nix` holds shared basics, `desktop.nix` adds
desktop, development, and SSH features, and `portable.nix` lists the tools of
the portable shell (see [portable.md](portable.md)).

## Ownership

- Noctalia owns wallpaper, including its JSON state. Stylix owns colors, fonts,
  cursor, and application theming only; do not set `stylix.image`.
- Niri owns compositor behavior, keybindings, window rules, and output
  defaults. wlr-randr wrappers are for emergency display changes.
- Niri is the nixpkgs release package from cache.nixos.org, set up by the
  nixpkgs `programs.niri` NixOS module (`modules/desktop/niri/system.nix`) and
  configured through Home Manager's free-form `wayland.windowManager.niri`
  settings (`modules/desktop/niri/home/`), which runs `niri validate` on every
  build. Stylix has no target for that module, so `modules/theme/system.nix`
  sets niri's cursor. Rejected in November 2026: niri-flake, which had no
  commit since August 2026, built an unreleased niri locally (no binary cache)
  with libdisplay-info 0.2 from a second nixpkgs, and whose typed settings
  could not express custom modes; keeping it only for that settings module
  would still lock its inputs. Also rejected: pinning upstream main, which
  means local builds of unreleased code on every update. Revisit only for a
  wanted feature that no release has yet, such as `max-bpc` on `kamo`.
- Niri ships no polkit agent, so `polkit-agent.service` runs polkit-kde-agent
  in Niri sessions. Noctalia 5.6 has its own agent (`shell.polkit_agent`), off
  by default (verified in its source); enabling it would need this unit gone.
- `modules/desktop/wayland.nix` owns the portal configuration. It blanks the
  nixpkgs niri module's `xdg.portal.config.niri`, because xdg-desktop-portal
  1.22 reads `niri-portals.conf` before `portals.conf` in the same directory
  (verified in its source), which would make GNOME the default portal and
  route Secret to GNOME Keyring. Home Manager's niri `portalPackage` is null,
  and `programs.niri.useNautilus` is off because the GTK portal is the file
  chooser.
- Niri's own session setup owns `DISPLAY` and the session environment: it
  starts xwayland-satellite on the first free X display and imports
  `WAYLAND_DISPLAY`, `DISPLAY`, and `XDG_CURRENT_DESKTOP` into systemd and
  D-Bus (verified in the niri 26.04 source). Do not set them in the niri
  config: on `desuwa` the headless Steam's gamescope holds `:0`, so niri
  listens on `:1`, and the hard-coded `DISPLAY ":0"` removed in November 2026
  sent X11 apps to Steam's server.
- Where Home Manager manages Zsh and Starship, it owns their initialization;
  `modules/core/users.nix` disables the duplicate NixOS initialization while
  keeping completion paths. Hosts without those features keep the NixOS
  defaults.
- Desktop SSH authentication uses Home Manager's `ssh-agent`. The GCR SSH agent
  is disabled to avoid a second agent.
- Desktops run no Secret Service: GNOME Keyring is disabled because fingerprint
  logins, autologin, and declarative password changes leave it locked. Noctalia
  encrypts its storage with the shared agenix `noctalia-storage-key`; changing
  that key does not migrate existing encrypted history.
- Nix store deduplication runs on the weekly `nix-optimise` timer, not on every
  store import, so identical files can briefly use extra space.
- On `dayo`, systemd-networkd and nftables own networking; NetworkManager comes
  only from the desktop profile.
- On `desuwa`, Steam runs only as the `steamhost` user in a headless gamescope;
  the desktop user has no Steam (see
  [hosts/desuwa/README.md](../hosts/desuwa/README.md)).
- On `kamo`, Jovian owns Gaming Mode, SDDM, input integration, and charging
  limits; Niri is the development desktop (see
  [hosts/kamo/README.md](../hosts/kamo/README.md)).

## Flake inputs

- `flake.lock` pins the inputs. tack, a replacement for it, was evaluated in
  November 2026 and not adopted: its own resolver would evaluate every host
  while the tool is six months old and on its second major version, and
  nothing here needs its input patching or signature checks. Revisit if an
  input needs standing patches or verified signatures.
- An input follows `nixpkgs` when only its modules are used, because those
  build with the host's pkgs (verified with `diff-config` for disko,
  nixos-hardware, and treefmt-nix). The nix-unit check and nix-direnv fetch
  every locked input, so each separate nixpkgs costs about 500 MB.
- Two nix-unit tests in `modules/flake/tests.nix` keep the lock lean: the
  nixpkgs sources it locks (GitHub `NixOS/nixpkgs` and nixos.org channel
  tarballs, named by their path from the root such as `nixpkgs-ytdlp`) must
  equal an allowlist (today the root `nixpkgs` and `nixpkgs-ytdlp`), and every
  root input must be referenced from Nix source outside the `inputs` block
  (`inputs.<name>`, `inputs'.<name>`, `inherit (inputs) <name>`) or be the
  target of another input's `follows`.
  Adding a nixpkgs or an input that only reaches the code some other way
  means updating the allowlist or referencing it that way. Both were verified
  to fail on a dropped `follows` and a re-added unused input.
- Left as upstream locks them: the nested flake-parts, nixpkgs-lib, and
  treefmt-nix copies (about 5 MB together; following would evaluate Stylix and
  agenix-rekey with a flake-parts they were not tested with).

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
| NixOS login shell and global shell initialization        | `modules/core/users.nix`                                 |
| User-facing shell settings                               | `modules/home/shell/`                                    |
| Default kernel (`dayo` overrides it in `hardware.nix`)   | `modules/core/boot.nix`                                  |
| Portable shell tools                                     | `modules/profiles/home/portable.nix`                     |
| How the portable shell finds their configuration         | `modules/flake/portable.nix`                             |
| `desuwa`'s headless Remote Play host                     | `modules/gaming/headless-host.nix`                       |
| Niri settings shared by the desktops                     | `modules/desktop/niri/home/`                             |
| `kamo` gaming and session integration                    | `modules/gaming/jovian.nix`                              |
| `dayo`'s router and backup server                        | `modules/services/router.nix`, `backup-server.nix`       |
| `dayo`'s line facts and backup quotas                    | `hosts/dayo/system.nix`                                  |
| State that survives reboots on `dayo`'s tmpfs root       | `modules/storage/ephemeral-root.nix`                     |
| Backup clients (not imported yet)                        | `modules/services/backup-client.nix`                     |
| Evaluated host and `flake.lock` invariants (nix-unit)    | `modules/flake/tests.nix`                                |
| Checks that build or boot something, such as VM tests    | `modules/flake/checks.nix`                               |

Display outputs are set with `my.display.outputs`, keyed by output name; set
`enable = false` to keep a known external display disabled. The wallpaper,
`my.wallpaper.image`, is shared across displays; when it is `null`, Niri uses
`my.wallpaper.fallbackColor` as a solid background.
