{ pkgs, lib, ... }:

let
  agentInstructions = import ./agent-instructions.nix;

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

in
{
  home = {
    packages = with pkgs; [ opencode ];
    file.".config/opencode/opencode.jsonc".text = lib.generators.toJSON { } opencodeConfig;
    file.".config/opencode/AGENTS.md".text = agentInstructions;
  };
}
