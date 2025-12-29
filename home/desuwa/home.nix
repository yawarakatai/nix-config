{ vars, ... }:

{
  imports = [
    ../../home
    ../../modules/home/media/obs.nix
    ../../modules/home/media/spicetify.nix
    ../../modules/home/creative
    ../../modules/home/dev/claude-code.nix
    ../../modules/home/browser/zen-browser.nix
  ];

  home.username = vars.username;
  home.homeDirectory = "/home/${vars.username}";
}
