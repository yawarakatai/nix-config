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
    # Environment
    - NixOS + flakes, Zsh
    - System rebuild: `nh os switch`
    - Home rebuild: `home-manager switch`
    - Dev shell: `nix develop` (never `nix-shell`)

    # System Configuration
    - Never modify /etc directly
    - Edit declarative Nix files only

    # Code Style
    - Write concise, readable, self-documenting code
    - Follow DRY, KISS, YAGNI
    - All comments in English

    # Commit
    - Messages in English, conventional commit format
    - Before committing: `nix flake check && nix fmt`

    # Languages
    - Systems/FFI/embedded: Rust or C
    - CLI/scripting: Rust or Python
    - Frontend/Node: TypeScript (strict)
    - Config/packaging: Nix

    # General
    - Prefer FOSS tooling
  '';
in
{
  home.packages = with pkgs; [ opencode ];
  home.file.".config/opencode/opencode.jsonc".text = lib.generators.toJSON { } opencodeConfig;
  home.file.".config/opencode/AGENTS.md".text = opencodeInstructions;
}
