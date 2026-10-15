_: {
  imports = [
    ./steam.nix
  ];

  programs = {
    gamemode.enable = true;

    gamescope = {
      enable = true;
      capSysNice = true;
    };
  };
}
