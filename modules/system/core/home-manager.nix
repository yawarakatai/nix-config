{ config, inputs, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${config.my.user.name} = import ../../../home/${config.networking.hostName}/home.nix;
    extraSpecialArgs = { inherit inputs; };
    backupFileExtension = "backup";
  };
}
