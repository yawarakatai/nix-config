{ pkgs, lib, ... }:

let
  agentInstructions = import ./agent-instructions.nix;

  claudeSettings = {
    permissions = {
      allow = [
        "Bash(nix:*)"
        "Bash(cargo:*)"
        "Bash(git:*)"
        "Bash(python3:*)"
        "Bash(zsh:*)"
      ];
      deny = [
        "Bash(curl:*)"
        "Bash(wget:*)"
        "Bash(nc:*)"
        "Read(.env)"
        "Read(.env.*)"
        "Read(**/secrets/**)"
        "Read(~/.ssh/**)"
        "Read(~/.gnupg/**)"
        "Write(/etc/**)"
        "Write(~/.ssh/**)"
      ];
    };
    env.CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";
  };

in
{
  home.packages = with pkgs; [ claude-code ];

  home.file.".claude/settings.json".text = lib.generators.toJSON { } claudeSettings;
  home.file.".claude/CLAUDE.md".text = agentInstructions;
}
