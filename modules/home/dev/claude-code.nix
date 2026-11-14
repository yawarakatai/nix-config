{ lib, pkgs, ... }:

{
  programs.claude-code = {
    enable = true;
    context = ''
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
      - `gh` is read-only: for writes such as PRs or comments, give the user the command instead of seeking other credentials.
      - `git push` needs a physical FIDO key touch with no visible prompt: warn the user first, and never retry or change remote URLs.

      ## Safety

      - Never overwrite, revert, or reformat unrelated user changes.
      - Never commit or print plaintext secrets or private keys.
      - Ask before destructive or privileged actions.
    '';
    mcpServers.nixos.command = lib.getExe pkgs.mcp-nixos;
    lspServers.nix = {
      command = lib.getExe pkgs.nixd;
      extensionToLanguage.".nix" = "nix";
    };

    # Claude Code rewrites settings.json itself (theme, /config changes), so
    # declared values are merged into a writable file instead of a store symlink.
    mutableSettings = true;

    settings = {
      # The package is pinned by Nix; the built-in updater cannot replace it.
      env.DISABLE_AUTOUPDATER = "1";

      permissions = {
        # Routine read-only and validation commands that should not prompt.
        allow = [
          "Bash(git status:*)"
          "Bash(git diff:*)"
          "Bash(git log:*)"
          "Bash(git show:*)"
          "Bash(nix eval:*)"
          "Bash(nix flake check:*)"
          "Bash(nix fmt:*)"
          "Bash(nix build:*)"
        ];

        # Command blocklists are easy to bypass and the YubiKey already guards
        # privileged actions, so only keep plaintext secrets out of context.
        ask = [ ];
        deny = [
          "Read(/run/agenix/**)"
          "Read(~/.ssh/id_*)"
          "Read(**/.env)"
          "Read(**/.env.*)"

          # Comes from the claude.ai account, so there is no local config to remove.
          "mcp__claude_ai_Claude_Docs"
        ];
      };
    };
  };
}
