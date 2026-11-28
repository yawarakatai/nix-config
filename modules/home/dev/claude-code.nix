{ lib, pkgs, ... }:

{
  programs.claude-code = {
    enable = true;
    # The Code section used to lead with "smallest change that works" and
    # YAGNI/KISS, which seemed to bias agents toward workarounds over structural
    # fixes (an impression, not measured), so it now leads with fixing the cause
    # and defines simplicity by the resulting code rather than the diff.
    context = ''
      # Global Agent Instructions

      ## Environment

      - The machine runs NixOS; most tools are not installed globally.
      - If a project tool is missing, use `direnv exec . <cmd>` when `.envrc` exists, otherwise `nix develop -c <cmd>`.
      - For one-off tools, use `nix shell nixpkgs#<pkg> -c <cmd>` instead of global or imperative installs (`pip install`, `npm -g`, `cargo install`).

      ## Decisions

      - When asked whether something is worthwhile or how it would go, answer with a recommendation and its trade-offs; implement only once the user decides.
      - When it is unclear which option is right or how something behaves, run a small experiment and decide from the result instead of guessing. What only the user can decide (preference, scope, risk) still goes to the user.

      ## Code

      - Fix the cause, not the symptom: when a problem comes from the structure, change the structure instead of adding a workaround, even if the diff is larger. If that reaches well beyond the task, propose it first.
      - Simple means the resulting code, not the size of the diff.
      - Delete dead or superseded code instead of commenting it out or keeping compatibility shims; history preserves it.
      - Do not build for needs that are not there yet; prefer a little duplication over premature abstraction.
      - Prefer existing dependencies and the standard library; each new dependency needs a clear reason. Do not major-upgrade dependencies or update lockfiles unless the task needs it.
      - Handle recoverable errors explicitly rather than panicking.
      - Comments explain why, not what, and are in English whatever language the conversation is in.

      ## Tests

      - Where a project has tests, whatever failed once stays as a test that would catch it again: reproduce a bug with a failing test before fixing it, and do the same for a regression or a wrong assumption found along the way.
      - Cover new logic that has non-obvious edge cases; do not add a test framework unasked.
      - Never weaken, skip, or delete a test to make it pass; fix the code or report the failure.

      ## Documentation

      - In the same change, record in a committed Markdown file what the code cannot show: what was verified and how, what was decided and why, what was tried and failed, and what is still undecided. Use the project's existing docs where they fit.
      - The conversation, agent memory, published artifacts, and temporary files do not count; they do not travel with the repository.

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
    lspServers = {
      nix = {
        command = lib.getExe pkgs.nixd;
        extensionToLanguage.".nix" = "nix";
      };
      # Resolved from PATH rather than pinned, so each project's dev shell
      # supplies the rust-analyzer that matches its toolchain.
      rust-analyzer = {
        command = "rust-analyzer";
        extensionToLanguage.".rs" = "rust";
      };
    };

    # Claude Code rewrites settings.json itself (theme, /config changes), so
    # declared values are merged into a writable file instead of a store symlink.
    # Declared values win on every activation, but a key removed here stays in
    # the file until it is deleted there.
    mutableSettings = true;

    settings = {
      # The instructions are in English, which pulls replies toward English even
      # in a Japanese conversation. The key exists in 2.1.321; whether it fully
      # stops the drift is untested.
      language = "japanese";

      # Synced from the claude.ai account and never used; their descriptions
      # cost ~2.4k tokens of context every session.
      skillOverrides = lib.genAttrs (map (s: "anthropic-skills:${s}") [
        "built-in-browser"
        "chrome-browser"
        "computer-use"
        "deep-research"
        "docs"
        "docx"
        "google-workspace"
        "import-memory"
        "morning"
        "pdf"
        "pptx"
        "skill-creator"
        "xlsx"
      ]) (_: "off");

      permissions = {
        defaultMode = "auto";

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
          # Read rules need `//` to mean the filesystem root: a single leading
          # slash anchors at ~/.claude and no slash at the working directory
          # (checked on 2.1.321). `.env.*` leaves `.envrc` readable.
          "Read(//run/agenix/**)"
          "Read(~/.ssh/id_*)"
          "Read(//**/.env)"
          "Read(//**/.env.*)"

          # Comes from the claude.ai account, so there is no local config to remove.
          "mcp__claude_ai_Claude_Docs"
        ];
      };
    };
  };
}
