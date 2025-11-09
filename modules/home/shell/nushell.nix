{ config
, pkgs
, theme
, ...
}:

{
  programs.nushell = {
    enable = true;

    # Shell init commands - register plugin here
    shellAliases = {
      cc = "cd ~/.config/nix-config";

      # Git aliases
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gcm = "git commit -am";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";
      gm = "git merge";
      gb = "git branch";
      gco = "git checkout";
    };

    # Environment variables
    environmentVariables = {
      EDITOR = "hx";
      VISUAL = "hx";
      PAGER = "bat";
    };
  };

  # Install nu_plugin_skim
  home.packages = with pkgs; [
    nushellPlugins.skim
  ];
}
