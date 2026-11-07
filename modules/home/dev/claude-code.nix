let
  agentInstructions = import ./agent-instructions.nix;
in
{
  programs.claude-code = {
    enable = true;
    context = agentInstructions;

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
          "Bash(nix develop -c just check)"
          "Bash(just check)"
        ];

        # Command blocklists are easy to bypass and the YubiKey already guards
        # privileged actions, so only keep plaintext secrets out of context.
        ask = [ ];
        deny = [
          "Read(/run/agenix/**)"
          "Read(~/.ssh/id_*)"
          "Read(**/.env)"
          "Read(**/.env.*)"
        ];
      };
    };
  };
}
