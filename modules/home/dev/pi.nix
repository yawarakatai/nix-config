_:

let
  agentInstructions = import ./agent-instructions.nix;
in
{
  programs.pi-coding-agent = {
    enable = true;
    settings = {
      defaultProvider = "openai-codex";
      defaultThinkingLevel = "low";
      enabledModels = [
        "gpt-6-luna"
        "gpt-6.1-sol"
      ];
    };
  };

  home.file.".pi/agent/AGENTS.md".text = agentInstructions;
}
