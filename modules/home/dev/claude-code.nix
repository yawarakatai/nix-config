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
in
{
  home = {
    packages = with pkgs; [ claude-code ];
    file.".claude/settings.json".text = lib.generators.toJSON { } claudeSettings;
    file.".claude/CLAUDE.md".text = agentInstructions;
  };
}
