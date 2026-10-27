{ inputs, username, ... }:

{
  imports = [
    inputs.jovian.nixosModules.default
    ./steam-client.nix
  ];

  jovian = {
    steam = {
      enable = true;
      autoStart = true;
      user = username;
    };

    # Keep the existing host's storage, memory, and kernel tuning.
    steamos.useSteamOSConfig = false;
  };
}
