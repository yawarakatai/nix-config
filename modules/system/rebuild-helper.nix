{ pkgs, vars, ... }:

{
  # Helper scripts for nixos-rebuild
  environment.systemPackages = [
    # not: nixos-rebuild test
    (pkgs.writeShellScriptBin "nd" ''
      sudo nixos-rebuild dry-build --flake ~/.config/nix-config#${vars.hostname} "$@"
    '')

    # not: nixos-rebuild test
    (pkgs.writeShellScriptBin "nt" ''
      sudo nixos-rebuild test --flake ~/.config/nix-config#${vars.hostname} "$@"
    '')

    # nos: nixos-rebuild switch
    (pkgs.writeShellScriptBin "ns" ''
      sudo nixos-rebuild switch --flake ~/.config/nix-config#${vars.hostname} "$@"
    '')

    # nob: nixos-rebuild boot
    (pkgs.writeShellScriptBin "nb" ''
      sudo nixos-rebuild boot --flake ~/.config/nix-config#${vars.hostname} "$@"
    '')

    # nou: update flake and rebuild
    (pkgs.writeShellScriptBin "nus" ''
      cd ~/.config/nix-config
      nix flake update
      sudo nixos-rebuild switch --flake ~/.config/nix-config#${vars.hostname} "$@"
    '')

    # noc: check flake
    (pkgs.writeShellScriptBin "nfc" ''
      cd ~/.config/nix-config
      nix flake check "$@"
    '')

    #nog: garbage collect
    (pkgs.writeShellScriptBin "ngc" ''
      sudo nix-collect-garbage --delete-older-than 30d
      nix-store --optimise
    '')
  ];

  # Optional: sudo without password for nix commands
  security.sudo.extraRules = [
    {
      users = [ vars.username ];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = [ "NOPASSWD" "SETENV" ];
        }
        {
          command = "/run/current-system/sw/bin/nix-collect-garbage";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${pkgs.nix}/bin/nix-store";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
