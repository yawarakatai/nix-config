{ config, pkgs, vars, ... }:

{
  programs.firefox = {
    enable = true;

    settings = {
      "browser.download.dir" = "/home/{vars.username}";
    };
  };
}
