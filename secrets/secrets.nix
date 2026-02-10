let
  keys = import ./keys.nix;
in
{
  "user-password.age".publicKeys =
    (builtins.attrValues keys.yubikey)
    ++ (builtins.attrValues keys.hosts)
    ++ (builtins.attrValues keys.master);

  "ha-token.age".publicKeys =
    (builtins.attrValues keys.yubikey) ++ [ keys.hosts.daze ] ++ (builtins.attrValues keys.master);
}
