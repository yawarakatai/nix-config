{ lib, config, pkgs, vars, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
    file
    pciutils
    usbutils
  ];

  virtualisation.docker.enable = false;

  users = {
    mutableUsers = false;
    users.${vars.username} = {
      isNormalUser = true;
      description = vars.username;
      extraGroups = [ "networkmanager" "wheel" "video" "audio" "plugdev" ] ++ lib.optional config.virtualisation.docker.enable "docker";
      shell = pkgs.nushell;
    };
    users.root.hashedPassword = "!"; # Disable root login
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "root" vars.username ];
    };

    # gc = {
    #   automatic = true;
    #   dates = "weekly";
    #   options = "--delete-older-than 30d";
    # };

    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      max-jobs = auto
    '';
  };

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = let
        ttySession = pkgs.writeTextDir "share/wayland-sessions/tty.desktop" ''
          [Desktop Entry]
          Name=TTY
          Comment=Drop to shell
          Exec=${pkgs.bashInteractive}/bin/bash
          Type=Application
        '';
      in "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${ttySession}/share/wayland-sessions:/run/current-system/sw/share/wayland-sessions:/run/current-system/sw/share/xsessions";
      user = "greeter";
    };
  };

  programs.niri.enable = true;

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 4d --keep 3";
    };
    flake = "/home/${vars.username}/.config/nix-config";
  };

  services.openssh = {
    enable = false;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  services.gvfs.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.dconf.enable = true;
  programs.xwayland.enable = true;
  nixpkgs.config.allowUnfree = true;
}
