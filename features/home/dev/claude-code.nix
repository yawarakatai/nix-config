{ pkgs, lib, ... }:

let
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

  globalClaudeMd = ''
    # Global Claude Instructions

    ## Environment
    - OS: NixOS with Nix flakes
    - Shell: Zsh

    ## Code Style
    - Prefer functional programming style
    - Always use Nix-specific approaches (flakes, overlays, devShells) over FHS-based solutions
    - Write all code comments in English

    ### Language selection by domain:
      - Systems / embedded / FFI: Rust or C
      - CLI tools / scripting / automation: Python or Rust
      - Frontend / Node tooling: TypeScript (strict mode)
      - NixOS config / packaging: Nix
    - Avoid suggesting Go, Java, Kotlin, Ruby, or other non-stack languages

    ## Nix Conventions
    - Use `nix develop` for dev environments, never `nix-shell`
    - Prefer `lib.*` functions over raw Nix builtins where available
    - Format with `nixfmt-rfc-style`

    ## General
    - Concise responses; no redundant explanations
    - Prefer FOSS tooling
  '';

in
{
  home.packages = with pkgs; [ claude-code ];

  home.file.".claude/settings.json".text = lib.generators.toJSON { } claudeSettings;
  home.file.".claude/CLAUDE.md".text = globalClaudeMd;
}
