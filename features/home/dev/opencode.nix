{ pkgs, lib, ... }:

let
  opencodeConfig = {
    "$schema" = "https://opencode.ai/config.json";
    share = "disabled";
    autoupdate = false;
    instructions = [ "AGENTS.md" ];
    permission = {
      read = "allow";
      edit = "ask";
      glob = "allow";
      grep = "allow";
      list = "allow";
      webfetch = "ask";
      bash = {
        "*" = "ask";
        "nix flake *" = "allow";
        "nix fmt" = "allow";
        "nix build *" = "allow";
        "nix develop *" = "allow";
        "nix *" = "ask";
        "home-manager *" = "allow";
        "git *" = "allow";
        "curl *" = "deny";
        "wget *" = "deny";
        "nc *" = "deny";
        "sudo *" = "deny";
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
