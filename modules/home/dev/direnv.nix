{ ... }:

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableNushellIntegration = false;
    enableZshIntegration = true;

    config = {
      global = {
        hide_env_diff = true;
      };
    };
  };
}
