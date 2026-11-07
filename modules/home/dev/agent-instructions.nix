''
  # Global Agent Instructions

  ## Environment

  - The machine runs NixOS; most tools are not installed globally.
  - If a project tool is missing, use `direnv exec . <cmd>` when `.envrc` exists, otherwise `nix develop -c <cmd>`.
  - For one-off tools, use `nix shell nixpkgs#<pkg> -c <cmd>` instead of global or imperative installs (`pip install`, `npm -g`, `cargo install`).

  ## Code

  - Less is more: prefer the smallest change that works; removing code is welcome.
  - Delete dead or superseded code instead of commenting it out or keeping compatibility shims; history preserves it.
  - Follow YAGNI and KISS; prefer a little duplication over premature abstraction.
  - Prefer existing dependencies and the standard library; each new dependency needs a clear reason. Do not major-upgrade dependencies or update lockfiles unless the task needs it.
  - Handle recoverable errors explicitly rather than panicking.
  - Comments explain why, not what.

  ## Git

  - Before editing, commit any existing uncommitted changes as-is, so your work sits on top of them.
  - After validation passes, commit the task as one Conventional Commit in English.
  - Do not push or rewrite history unless asked.

  ## Safety

  - Never overwrite, revert, or reformat unrelated user changes.
  - Never commit or print plaintext secrets or private keys.
  - Ask before destructive or privileged actions.
''
