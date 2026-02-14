{ config, inputs, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${config.my.user.name} = import ../../../hosts/${config.networking.hostName}/home;
    extraSpecialArgs = { inherit inputs; };
    backupFileExtension = "backup";
  };
}
