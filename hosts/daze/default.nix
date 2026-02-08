{
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ../../lib/options.nix
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];

  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
  };

  boot.kernelParams = lib.mkForce [ ];

  hardware.raspberry-pi."4".fkms-3d.enable = false;

  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  my.user.name = "yawarakatai";

  users.mutableUsers = false;
  users.users.yawarakatai = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.nushell;
    hashedPassword = "$6$/JCsg6Ab3cxB4wWV$4xFaUJGPbaxFw2inJ1Z6KJ.9w5aHg3JnRTHoGUeH62Rbmjja5shQvY6mGG0K5yjMBz1ejnu9QHr5i3MtC.Qr30";
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKoUC9mEqLf9q8geELb89t8I9P+0JBD2fvm51+jwNuu3AAAABHNzaDo= yubikey_5"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIFwdOpc6zvMiZ0zC/NqC2mzEn0B5hdRz1jD2V76vsclLAAAABHNzaDo= yubikey_5c"
    ];
  };
  users.users.root.hashedPassword = "!";

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    htop
  ];

  system.stateVersion = "25.05";
}
