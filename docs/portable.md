# Portable shell

`packages.<system>.portable` is a Zsh with the everyday CLI tools and their
configuration, for Linux machines where Nix cannot be installed system-wide,
such as school PCs. It changes nothing on the machine: it does not touch
`~/.bashrc`, `~/.profile`, or `~/.config`, and exiting the shell returns to the
machine's own environment.

It includes the CLI tools, Helix, Zsh with Starship and zoxide, Git with yawarakatai's
identity, Lazygit, direnv with nix-direnv, Nix tools (nixd, nixfmt, comma),
Python, Plainix, Claude Code, and yawarakatai's SSH host settings
(`modules/profiles/home/portable.nix`). It does not include the desktop,
Ghostty, or system services.

## Before using

On a school or other managed device, obtain permission to run these tools. Do
not bypass device restrictions; if running programs from your home directory
is blocked, ask the administrator.

## Run it

With Nix installed:

```bash
nix run github:yawarakatai/nix-config#portable
```

Without root, use [nix-portable](https://github.com/DavHau/nix-portable), a
single Nix binary that keeps its store in `~/.nix-portable`:

```bash
mkdir -p ~/.local/bin
curl -L -o ~/.local/bin/nix-portable \
  "https://github.com/DavHau/nix-portable/releases/latest/download/nix-portable-$(uname -m)"
chmod +x ~/.local/bin/nix-portable
~/.local/bin/nix-portable nix run github:yawarakatai/nix-config#portable
```

Undecided: nix-portable has not been tried with this flake yet, and its latest
release (v012, 2024) bundles an older Nix. nix-portable is fast only when
unprivileged user namespaces work; otherwise it falls back to the much slower
proot. Ubuntu 24.04 and later can restrict them through AppArmor. Check with:

```bash
unshare --user --map-root-user true && echo userns-ok
cat /proc/sys/kernel/apparmor_restrict_unprivileged_userns 2>/dev/null  # 1 = restricted
```

The first run downloads about 2.4 GiB. Arguments after `--` are passed to Zsh, so
`nix run …#portable -- -c '<command>'` runs one command. To pick up new commits, add
`--refresh` to `nix run`. Old versions stay in the store until
`nix store gc` (`nix-portable nix store gc`).

## What it writes to your home

Only what the tools write themselves: Zsh history in `~/.zsh_history`, caches
and state under `~/.cache`, `~/.local/state`, and `~/.local/share`, and an
empty `~/.config/lazygit`.

## SSH

The `ssh` command uses the bundled configuration. It reads the YubiKey handles
from `~/.ssh/yubikey_5` and `~/.ssh/yubikey_5c` and pins host keys alongside
your own `~/.ssh/known_hosts`. The handles are resident on each key; export them
once with `cd ~/.ssh && ssh-keygen -K` (PIN required) and rename the
`id_ed25519_sk_rk_nix-config` file to `yubikey_5` or `yubikey_5c`.

## How it works

`modules/flake/portable.nix` evaluates the Home Manager profile with a
placeholder home, `/homeless-shelter`, and never activates it. The launcher
points each tool at the rendered files in the store:

| Tool                                           | How it finds its configuration                    |
| ---------------------------------------------- | ------------------------------------------------- |
| Git, Lazygit, Starship, Yazi, television, direnv | `GIT_CONFIG_GLOBAL`, `LG_CONFIG_FILE`, `STARSHIP_CONFIG`, `YAZI_CONFIG_HOME`, `TELEVISION_CONFIG`, `DIRENV_CONFIG` |
| Helix                                          | an `hx` wrapper that sets `XDG_CONFIG_HOME` for Helix only |
| SSH                                            | an `ssh` wrapper that passes `-F`                 |
| Zsh                                            | `ZDOTDIR`, whose `.zshenv` also sets `PATH`, since `/etc/zshenv` may reset it (NixOS does) |

A tool added to the profile that reads `~/.config` silently runs without its
configuration until it gets a variable or wrapper here. Evaluation fails if a
session variable still points into the placeholder home; the rendered files the
launcher uses were checked for it by hand.

Limits:

- Claude Code's global instructions, MCP servers, and LSP servers live under
  `~/.claude`; only the binary is included, because relocating that directory
  with `CLAUDE_CONFIG_DIR` would also move the login.
- `bat` and `bottom` run with their defaults, as they have no rendered
  configuration.

Verified on desuwa with an empty `HOME` and `env -i`: every tool resolves from
the package, and Helix (`hx --health`), Git, Starship (`starship print-config`),
SSH (`ssh -G`), direnv (`direnv status`), television (`tv list-channels`),
and Lazygit and Yazi (`strace` of their startup) read the bundled files.
television writes a default `config.toml` when it is missing, so an empty one is
rendered.

Rejected alternatives:

- Standalone Home Manager activated into the home. It replaced `~/.bashrc` and
  `~/.profile`, needed `/nix`, and so root, and needed the account and features
  passed through `PORTABLE_*` variables with `--impure` on every update. Under
  nix-portable its `~/.config` symlinks would also dangle outside the sandbox
  and break the host's own Git and other programs (assumed, not tried).
- A private `XDG_CONFIG_HOME` holding symlinks to the rendered files. It hides
  the rest of `~/.config` from the shell, and configuration that tools create
  there is invisible outside it.
- Selectable optional features: the shell has a single user, so one fixed set
  is enough.
