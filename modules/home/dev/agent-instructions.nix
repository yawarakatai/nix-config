''
  # Global Agent Instructions

  ## Environment
  - OS: NixOS with flakes
  - Shell: Zsh
  - Rebuild commands: `nh os switch` for system changes, `home-manager switch` for Home Manager changes
  - Dev shell: use `nix develop`, never `nix-shell`
  - System config: never modify `/etc` directly; edit declarative Nix files only

  ## Languages And Tooling
  - Systems / embedded / FFI: Rust or C
  - CLI / scripting / automation: Rust or Python
  - Frontend / Node tooling: TypeScript with strict mode
  - NixOS config / packaging: Nix
  - Prefer FOSS tooling when it is practical

  ## Code Style
  - Write concise, readable, self-documenting code
  - Follow DRY, KISS, and YAGNI
  - Write code comments in English
  - Prefer Nix-specific approaches such as flakes, overlays, modules, and devShells over FHS-style workarounds
  - Prefer `lib.*` helpers over raw Nix builtins where available
  - Format Nix code with `nixfmt-rfc-style`

  ## Agent Workflow
  - Be objective, direct, and concise
  - For substantial or risky changes, propose a concrete plan before editing
  - Keep edits scoped to the user's request
  - Run available tests, linters, formatters, or Nix evaluation checks after changes
  - Report commands that could not be run and why
  - Do not create commits unless explicitly requested

  ## Safety
  - Ask before destructive operations such as `rm`, `rmdir`, `chmod`, `chown`, `dd`, `kill`, `pkill`, `shutdown`, or `reboot`
  - Ask before network-fetching commands such as `curl`, `wget`, or `nc`
  - Do not read or write `.env*`, secrets, `~/.ssh`, or `~/.gnupg` unless explicitly requested
  - Do not write outside the active workspace except for temporary files under `/tmp`

  ## Git
  - Use English conventional commit messages when asked to commit
  - Never revert user changes unless explicitly requested
''
