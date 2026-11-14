# Syncthing itself runs from ./home.nix; only the system firewall lives here.
_:

{
  networking.firewall = {
    allowedTCPPorts = [ 22000 ];
    allowedUDPPorts = [
      22000
      21027
    ];
  };
}
