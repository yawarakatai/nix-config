{ pkgs, ... }:

{
  containers.dev = {
    autoStart = false;
    ephemeral = true;
    bindMounts."/data/projects".hostPath = "/data/projects";
    config = { pkgs, ... }: {
      services.openssh.enable = true;
      environment.systemPackages = with pkgs; [
        git
        neovim
      ];
    };
  };
}
