let
  keys = import ./keys.nix;
  allKeys = (builtins.attrValues keys.yubikey) ++ (builtins.attrValues keys.hosts);
in
{
  "user-password.age".publicKeys = allKeys;
}
