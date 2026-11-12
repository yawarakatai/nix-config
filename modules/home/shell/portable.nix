{ config, lib, ... }:

{
  imports = [ ./default.nix ];

  # Changing the login shell on a non-NixOS host needs /etc/shells and chsh,
  # so interactive top-level Bash hands off to Zsh instead. Nested `bash` stays Bash.
  programs.bash.initExtra = lib.mkAfter ''
    if [[ $SHLVL -le 1 ]]; then
      exec ${lib.getExe config.programs.zsh.package}
    fi
  '';
}
