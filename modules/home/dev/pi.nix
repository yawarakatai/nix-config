_:

let
  agentInstructions = import ./agent-instructions.nix;
in
{
  programs.pi-coding-agent = {
    enable = true;
    settings = {
      defaultProvider = "openai-codex";
      defaultModel = "gpt-5.6-luna";
      defaultThinkingLevel = "xhigh";
      enabledModels = [
        "openai-codex/gpt-5.6-luna"
        "openai-codex/gpt-5.6-sol"
      ];
    };
  };

  home.file.".pi/agent/AGENTS.md".text = agentInstructions;
}
