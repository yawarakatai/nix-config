{ pkgs, ... }:

{
  home.packages = with pkgs; [
    claude-code
  ];

  xdg.configFile."claude-code/settings.json".text = builtins.toJSON {
    shell = "/run/current-system/sw/bin/bash";
  };
}
