# Git configuration with delta
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    delta
  ];

  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      pull.rebase = false;
      core.editor = "hx";

      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      delta = {
        navigate = true;
        light = false;
        line-numbers = true;
        syntax-theme = "base16";
      };

      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";

      # GitHub SSH keys are FIDO keys that need a touch per connection, so
      # reads (including lazygit auto-fetch) use HTTPS and only pushes use SSH.
      url."https://github.com/".insteadOf = "git@github.com:";
      url."git@github.com:".pushInsteadOf = [
        "git@github.com:"
        "https://github.com/"
      ];
    };
  };
}
