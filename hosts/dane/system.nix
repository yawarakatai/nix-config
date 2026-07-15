{
  lib,
  pkgs,
  username,
  ...
}:

{
  networking.hostName = lib.mkForce "dane";

  programs.zsh.enable = true;

  users = {
    mutableUsers = false;
    users.${username} = {
      isNormalUser = true;
      description = username;
      shell = pkgs.zsh;
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
      ];
      hashedPassword = "!";
    };
    users.root.hashedPassword = "!";
  };

  security.sudo.extraRules = [
    {
      users = [ username ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  powerManagement.cpuFreqGovernor = "schedutil";

  networking.firewall = {
    allowedTCPPorts = lib.mkForce [ 22 ];
    allowedUDPPorts = lib.mkForce [ ];
  };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="auto"
  '';
}
