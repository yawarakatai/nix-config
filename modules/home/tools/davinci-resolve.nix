{ config, pkgs, lib, ... }:

let
  # Wrap DaVinci Resolve to fix logging issues
  # The app tries to write to ./logs/rollinglog.txt which fails in NixOS
  # We create a wrapper that sets up a proper writable directory and changes CWD
  davinci-resolve-wrapped = pkgs.symlinkJoin {
    name = "davinci-resolve-wrapped";
    paths = [ pkgs.davinci-resolve ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/davinci-resolve \
        --run 'mkdir -p "$HOME/.local/share/DaVinciResolve/logs"' \
        --chdir "$HOME/.local/share/DaVinciResolve"
    '';
  };
in
{
  home.packages = [
    davinci-resolve-wrapped
  ];
}
