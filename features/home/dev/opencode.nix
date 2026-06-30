{ pkgs, lib, ... }:

let
  opencodeConfig = {
    "$schema" = "https://opencode.ai/config.json";
    share = "disabled";
    autoupdate = false;
    instructions = [ "AGENTS.md" ];
    permission = {
      bash = {
        "rm *" = "ask";
        "rmdir *" = "ask";
        "chmod *" = "ask";
        "kill *" = "ask";
        "pkill *" = "ask";
        "curl *" = "ask";
        "wget *" = "ask";
        "nc *" = "deny";
        "sudo *" = "deny";
        "chown *" = "deny";
        "dd *" = "deny";
        "shutdown *" = "deny";
        "reboot *" = "deny";
      };
      external_directory = {
        "/tmp/**" = "allow";
      };
    };
  };

  opencodeInstructions = ''
    # Environment & System

    - OS: NixOS + flakes, Zsh
    - Rebuild commands: `nh os switch` (System), `home-manager switch` (Home)
    - Dev shell: `nix develop` (NEVER use `nix-shell`)
    - System Config: NEVER modify `/etc` directly. Edit declarative Nix files only.

    # Languages & Tooling

    - Systems/FFI/embedded: Rust or C
    - CLI/scripting: Rust or Python
    - Frontend/Node: TypeScript (strict)
    - Config/packaging: Nix
    - Tooling Preference: FOSS solutions whenever possible.

    # Code Style

    - Philosophy: Write concise, readable, self-documenting code. Follow DRY, KISS, YAGNI.
    - Comments: English only.

    # Agent Workflow & Behavior

    - Tone: Objective, direct, concise. No flattery, apologies, or filler words.
    - Explanations: Anti-tutorial. Skip basic hand-holding. Focus on production-ready output. Show code first ("How"), then distill principles ("Why").
    - Formatting: Use Markdown for long texts. No interactive widgets or UI diagrams.

    ## Execution Protocol

    1. Propose a step-by-step plan.
    2. Wait for explicit user approval.
    3. Implement.
    4. Run all available tests, linters, and formatters. Fix any failures.
    5. Commit automatically (only if all checks pass).
       Do not jump straight to implementation without a confirmed plan.

    ## Scope & Granularity

    - Break complex tasks into discrete, focused steps. One logical module or concern per step.
    - Multi-file changes: implement and verify one unit at a time before proceeding.
    - When reviewing existing code: examine one logical unit at a time. Do not attempt to review an entire codebase in one pass.

    ## Quality & Proactivity

    - Verify against concrete evidence: documentation, type signatures, compiler/tool output, test results. Prefer evidence over confidence.
    - Point out security flaws, anti-patterns, or DRY/KISS violations bluntly.
    - Proactively suggest architecture improvements, refactoring, and optimizations — not just bug fixes.

    # Git

    - Messages: English, conventional commit format.

  '';
in
{
  home.packages = with pkgs; [ opencode ];
  home.file.".config/opencode/opencode.jsonc".text = lib.generators.toJSON { } opencodeConfig;
  home.file.".config/opencode/AGENTS.md".text = opencodeInstructions;
}
