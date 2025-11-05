{ config, pkgs, vars, ... }:

{
  # Helper scripts for nixos-rebuild
  environment.systemPackages = [
    # nos: nixos-rebuild switch
    (pkgs.writeShellScriptBin "nos" ''
      sudo nixos-rebuild switch --flake ~/.config/nix-config#${vars.hostname} "$@"
    '')
    
    # nob: nixos-rebuild boot
    (pkgs.writeShellScriptBin "nob" ''
      sudo nixos-rebuild boot --flake ~/.config/nix-config#${vars.hostname} "$@"
    '')
    
    # not: nixos-rebuild test
    (pkgs.writeShellScriptBin "not" ''
      sudo nixos-rebuild test --flake ~/.config/nix-config#${vars.hostname} "$@"
    '')
    
    # nou: update flake and rebuild
    (pkgs.writeShellScriptBin "nou" ''
      cd ~/.config/nix-config
      nix flake update
      sudo nixos-rebuild switch --flake ~/.config/nix-config#${vars.hostname} "$@"
    '')
    
    # noc: check flake
    (pkgs.writeShellScriptBin "noc" ''
      cd ~/.config/nix-config
      nix flake check "$@"
    '')
    
    #nog: garbage collect
    (pkgs.writeShellScriptBin "nog" ''
      sudo nix-collect-garbage --delete-older-than 30d
      nix-store --optimise
    '')
  ];
  
  # Optional: sudo without password for nixos-rebuild
  # Uncomment if you want to avoid typing password for rebuilds
  # security.sudo.extraRules = [
  #   {
  #     users = [ vars.username ];
  #     commands = [
  #       {
  #         command = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
  #         options = [ "NOPASSWD" ];
  #       }
  #     ];
  #   }
  # ];
}
