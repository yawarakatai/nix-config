{ pkgs, lib, ... }:

let
  agentInstructions = import ./agent-instructions.nix;

  claudeSettings = {
    "$schema" = "https://json.schemastore.org/claude-code-settings.json";
    permissions = {
      ask = [
        "Bash(rm:*)"
        "Bash(rmdir:*)"
        "Bash(chmod:*)"
        "Bash(kill:*)"
        "Bash(pkill:*)"
        "Bash(curl:*)"
        "Bash(wget:*)"
      ];
      deny = [
        "Bash(sudo:*)"
        "Bash(chown:*)"
        "Bash(dd:*)"
        "Bash(shutdown:*)"
        "Bash(reboot:*)"
        "Bash(nc:*)"
      ];
    };
  };

  claudeSettingsJson = lib.generators.toJSON { } claudeSettings;
in
{
  home = {
    packages = with pkgs; [ claude-code ];
    file.".claude/CLAUDE.md".text = agentInstructions;

    activation.ensureMutableClaudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      settings="$HOME/.claude/settings.json"

      # Home Manager previously managed this as a symlink into the read-only
      # Nix store. Claude Code updates settings atomically via a temporary file,
      # so it needs a normal writable file instead.
      if [ -L "$settings" ]; then
        rm -f "$settings"
      fi

      if [ ! -e "$settings" ]; then
        mkdir -p "$(dirname "$settings")"
        cat > "$settings" <<'EOF'
${claudeSettingsJson}
EOF
        chmod 600 "$settings"
      fi
    '';
  };
}
