_:

let
  agentInstructions = import ./agent-instructions.nix;
in
{
  programs.pi-coding-agent = {
    enable = true;
  };

  home.file.".pi/agent/AGENTS.md".text = agentInstructions;
}
