{ pkgs, lib, ... }:

let
  agentInstructions = import ./agent-instructions.nix;

  codexConfig = ''
    approval_policy = "on-request"
    sandbox_mode = "workspace-write"

    [shell_environment_policy]
    inherit = "core"
    ignore_default_excludes = false
    exclude = [
      "OPENAI_API_KEY",
      "ANTHROPIC_API_KEY",
      "GITHUB_TOKEN",
      "GH_TOKEN",
      "NPM_TOKEN",
      "NIX_ACCESS_TOKENS",
    ]
  '';
in
{
  home.packages = with pkgs; [ codex ];

  home.activation.codexConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          mkdir -p "$HOME/.codex"
          cat > "$HOME/.codex/config.toml" <<'EOF'
    ${codexConfig}
    EOF
          chmod u+w "$HOME/.codex/config.toml"
  '';

  home.file.".codex/AGENTS.md".text = agentInstructions;
}
