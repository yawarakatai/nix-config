let
  keys = import ./keys.nix;
in
{
  "user-password.age".publicKeys =
    (builtins.attrValues keys.yubikey)
    ++ (builtins.attrValues keys.hosts)
    ++ (builtins.attrValues keys.master);

  "yubikey-5-sk.age".publicKeys =
    (builtins.attrValues keys.yubikey)
    ++ (builtins.attrValues keys.hosts)
    ++ (builtins.attrValues keys.master);

  "yubikey-5c-sk.age".publicKeys =
    (builtins.attrValues keys.yubikey)
    ++ (builtins.attrValues keys.hosts)
    ++ (builtins.attrValues keys.master);

  "github-token-ro.age".publicKeys =
    (builtins.attrValues keys.yubikey)
    ++ (builtins.attrValues keys.hosts)
    ++ (builtins.attrValues keys.master);
}
