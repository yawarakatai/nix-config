{ inputs, username, ... }:
{
  imports = [ inputs.den.nixosModules.default ];

  services.den = {
    enable = true;
    readers = [ username ];
  };
}
