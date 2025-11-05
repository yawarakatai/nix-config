{ config, pkgs, ... }:

{
  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
    
    options = [
      "--cmd cd"  # Use 'cd' instead of 'z'
    ];
  };
}
