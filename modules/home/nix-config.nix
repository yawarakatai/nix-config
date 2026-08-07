{
  config,
  lib,
  pkgs,
  ...
}:
let
  repoDir = "${config.home.homeDirectory}/.config/nix-config";
  repoUrl = "https://github.com/yawarakatai/nix-config.git";
in
{
  home.file."nix-config" = {
    source = config.lib.file.mkOutOfStoreSymlink repoDir;
  };

  home.activation.bootstrapNixConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    repo=${lib.escapeShellArg repoDir}
    parent="$(${pkgs.coreutils}/bin/dirname "$repo")"

    if [ ! -e "$repo" ]; then
      echo "Bootstrapping nix-config into $repo"
      ${pkgs.coreutils}/bin/mkdir -p "$parent"

      tmp="$repo.clone.$$"
      ${pkgs.coreutils}/bin/rm -rf "$tmp"

      if ${pkgs.git}/bin/git clone \
        --branch main \
        --single-branch \
        ${lib.escapeShellArg repoUrl} \
        "$tmp"
      then
        ${pkgs.coreutils}/bin/mv "$tmp" "$repo"
      else
        echo "warning: failed to clone nix-config" >&2
        ${pkgs.coreutils}/bin/rm -rf "$tmp"
      fi
    elif [ ! -d "$repo/.git" ]; then
      echo "warning: $repo exists but is not a Git repository" >&2
    fi
  '';
}
