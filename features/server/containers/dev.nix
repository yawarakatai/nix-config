{ pkgs, ... }:

{
  containers.dev = {
    autoStart = true;
    ephemeral = false;
    privateNetwork = true;
    hostAddress = "10.0.1.1";
    localAddress = "10.0.1.2";
    bindMounts."/data/projects".hostPath = "/data/projects";
    config = { pkgs, ... }: {
      services.openssh.enable = true;
      networking.firewall.enable = false;
      environment.systemPackages = with pkgs; [
        git
        neovim
        htop
      ];
    };
  };
}
