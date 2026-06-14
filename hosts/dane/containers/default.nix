{ pkgs, ... }:

{
  systemd.tmpfiles.rules = [
    "d /data/projects 0755 yawarakatai users - -"
  ];

  containers.dev = {
    autoStart = true;
    ephemeral = false;
    privateNetwork = true;
    hostAddress = "10.0.1.1";
    localAddress = "10.0.1.2";

    bindMounts = {
      "/data/projects".hostPath = "/data/projects";
      "/home/dev/nix-config" = {
        hostPath = "/home/yawarakatai/nix-config";
        isReadOnly = true;
      };
      "/home/dev/.ssh" = {
        hostPath = "/home/yawarakatai/.ssh";
        isReadOnly = true;
      };
    };

    config = { pkgs, ... }: {
      programs.zsh.enable = true;

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      users.users.dev = {
        isNormalUser = true;
        initialPassword = "dev";
        extraGroups = [ "wheel" ];
        shell = pkgs.zsh;
      };

      services.openssh = {
        enable = true;
        settings.PasswordAuthentication = true;
      };

      environment.systemPackages = with pkgs; [
        direnv
        fd
        git
        helix
        jq
        lazygit
        nix
        ripgrep
        zellij
        zsh
      ];

      networking.firewall.enable = false;
      system.stateVersion = "25.05";
    };
  };
}
