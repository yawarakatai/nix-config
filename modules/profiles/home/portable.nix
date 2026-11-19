{ ... }:

{
  imports = [
    ../../home/cli
    ../../home/editor/helix.nix
    ../../home/dev
    ../../home/dev/git-identity.nix
    ../../home/dev/claude-code.nix
    ../../home/shell
    ../../ssh/client.nix
  ];

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
    PAGER = "less";
    LESS = "-R";
  };
}
